//
//  LWDataFetcher.m
//  LazyWeather
//
//  Created by JB on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWDataFetcher.h"
#import "LWDailyForecast.h"
#import "LWWeatherStore.h"

@import CoreLocation;

@interface LWDataFetcher () <CLLocationManagerDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation LWDataFetcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *config =
            [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
      
        NSLog(@"NSURL session initialized"); // @@@@@@  //
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
            
        }
        
        [self.locationManager requestLocation];

    }
    return self;
}

- (BOOL)updateWeather
{
    //grab coordinate
    // fetch data
    //return success
    return YES;
}

- (void)fetchDataForLatitude:(double)latitude andLongitude:(double)longitude
{
    NSString *requestString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f",self.key,latitude,longitude];
    
    NSLog(@"\n Requesting Data from %@ \n", requestString); // @@@@@ //
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
        [self.session dataTaskWithRequest:req
                        completionHandler:
         ^(NSData *data, NSURLResponse *response, NSError *error) {
             NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:nil];
             NSLog(@"JSON Request Returned: \n\n %@", jsonObject); // @@@@@ //
             
             if (error) {
                 // do stuff for error
             } else {
             
                 NSLog(@"completed Fetch"); // @@@@@ //
                 [self SendRelevantDataToWeatherStore:jsonObject];
             }
         }];
    
    [dataTask resume];
}

- (void)SendRelevantDataToWeatherStore:(NSDictionary *)jsonData
{
    NSArray *dailyData = jsonData[@"daily"][@"data"];
    
    for (NSMutableDictionary *day in dailyData) {
        
        
        NSNumber *unixTimeStamp = day[@"time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([unixTimeStamp doubleValue])];
        NSLog(@"Date = %@", date); // @@@@@@ //
        
        NSNumber *precipProbability = day[@"precipProbability"];
        
        NSNumber *high = day[@"temperatureMax"];
        NSNumber *low = day[@"temperatureMin"];
        NSString *summary = day[@"summary"];
        
        LWDailyForecast *newForecast = [[LWDailyForecast alloc] initWithPrecipitationProbability:[precipProbability integerValue]
                                                                                 HighTemperature:[high integerValue]
                                                                                  LowTemperature:[low integerValue]
                                                                                         Summary:summary
                                                                                            Date:date];
        [[LWWeatherStore sharedStore] addNewForecast:newForecast];
        
    }
}

#pragma mark - Accessors for Key

- (NSString *)key
{
    return @"09e4af1dabbf9a48bba445d3642c19f9";
}

- (void)setKey:(NSString *)key
{
    @throw [NSException exceptionWithName:@"Can't Set Key"
                                   reason:@"Key is to be a constant]"
                                 userInfo:nil];
}

#pragma mark - Location

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    NSLog(@"%@", [locations lastObject]);
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    CLLocation *currentLocation = [locations lastObject];
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
             NSLog(@"%@ %@\n%@ %@\n%@\n%@",
                                      self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                      self.placemark.postalCode, self.placemark.locality,
                                      self.placemark.administrativeArea,
                                      self.placemark.country);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];

}

//didFailWithError is required for compilation
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
