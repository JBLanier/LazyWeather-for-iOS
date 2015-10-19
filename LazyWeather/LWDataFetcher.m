//
//  LWDataFetcher.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWDataFetcher.h"
#import "LWDailyForecast.h"
#import "LWWeatherStore.h"
#import "LWWeatherUpdateManager.h"



@import CoreLocation;

@interface LWDataFetcher () <CLLocationManagerDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) void (^dataFetchCompletionHandler)(NSError *);

@end

@implementation LWDataFetcher

/**********************************************************************************************/
#pragma mark - Initialiazation
/**********************************************************************************************/


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *config =
            [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }

    }
    return self;
}

/**********************************************************************************************/
#pragma mark - BeginUpdatingWeather
/**********************************************************************************************/

- (void)beginUpdatingWeatherWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    self.dataFetchCompletionHandler = completionHandler;
    [self.locationManager requestLocation];
    
}

/**********************************************************************************************/
#pragma mark - CLLocationManager Delegate Methods
/**********************************************************************************************/

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [[LWWeatherUpdateManager sharedManager]UpdateWeatherAndNotificationsWithCompletionHandler:nil];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self displayLocationStatusAuthorizationAlert];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [self fetchJSONDataForLocation:[locations lastObject]];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.dataFetchCompletionHandler(error);
}

/**********************************************************************************************/
#pragma mark - Fetch JSON Data
/**********************************************************************************************/

- (void)fetchJSONDataForLocation:(CLLocation *)location
{
    double latitude  = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    NSString *requestString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f",self.key,latitude,longitude];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
        [self.session dataTaskWithRequest:req completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
    
             if (error) {
                 NSLog(@"JSON Request Failed: \n %@", error.debugDescription);
                 self.dataFetchCompletionHandler(error);
             } else {
                 [self SetLocalityForWeatherStore:location];
                 
                 NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:nil];
                 [self SendRelevantDataToWeatherStore:jsonObject];
             }
         }];
    
    [dataTask resume];
}

/**********************************************************************************************/
#pragma mark - Store Data in WeatherStore
/**********************************************************************************************/

- (void)SendRelevantDataToWeatherStore:(NSDictionary *)jsonData
{
    NSMutableArray *newWeatherStoreForecasts = [[NSMutableArray alloc] init];
    
    NSArray *dailyData = jsonData[@"daily"][@"data"];
    for (NSMutableDictionary *day in dailyData) {
        
        NSNumber *precipProbabilityPointer = day[@"precipProbability"];
        NSInteger precipProbability = precipProbabilityPointer.floatValue *100;
        NSNumber *highPointer = day[@"temperatureMax"];
        NSInteger high = highPointer.integerValue;
        NSNumber *lowPointer  = day[@"temperatureMin"];
        NSInteger low = lowPointer.integerValue;
        NSString *summary = day[@"summary"];
        
        NSNumber *unixTimeStamp = day[@"time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([unixTimeStamp doubleValue])];
        
        LWDailyForecast *newForecast = [[LWDailyForecast alloc] initWithPrecipitationProbability:precipProbability
                                                                                 HighTemperature:high
                                                                                  LowTemperature:low
                                                                                         Summary:summary
                                                                                            Date:date];
        [newWeatherStoreForecasts addObject:newForecast];
    }
    [[LWWeatherStore sharedStore] setNewForecasts:newWeatherStoreForecasts];
    
    self.dataFetchCompletionHandler(nil);
}

- (void)SetLocalityForWeatherStore:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *locationPlacemark = [placemarks lastObject];
            [LWWeatherStore sharedStore].localityOfForecasts = locationPlacemark.locality;
            
        } else {
            [LWWeatherStore sharedStore].localityOfForecasts = nil;
        }
    } ];
}

/**********************************************************************************************/
#pragma mark - Accessors for API Key
/**********************************************************************************************/

- (NSString *)key
{
    return @"09e4af1dabbf9a48bba445d3642c19f9";
}

- (void)setKey:(NSString *)key
{
    @throw [NSException exceptionWithName:@"Can't Modify Key"
                                   reason:@"Key is to be a constant]"
                                 userInfo:nil];
}

- (void) displayLocationStatusAuthorizationAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services Disabled"
                                                                             message:@"LazyWeather can't work properly without location sevices. You'll have to change this manually in settings."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
            [[UIApplication sharedApplication] openURL:settingsUrl];
        }
    }];
    
    [alertController addAction:actionOk];
    [alertController addAction:settingsAction];
    UIViewController* rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    [rootVC presentViewController:alertController animated:YES completion:nil];
}

@end
