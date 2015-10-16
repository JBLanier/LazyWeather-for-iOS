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
@property (nonatomic, weak) void (^dataFetchCompletionHandler)(NSError *);

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
            NSLog(@"requested location authorization");

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [self fetchJSONDataForLocation:[locations lastObject]];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Request Failed: \n %@", error.debugDescription);
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
                 NSLog(@"%@",jsonObject);
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
        
        NSNumber *precipProbability = day[@"precipProbability"];
        NSNumber *high = day[@"temperatureMax"];
        NSNumber *low  = day[@"temperatureMin"];
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
            NSLog(@"Reverse Geocoding Failed: \n %@", error.debugDescription);
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

@end
