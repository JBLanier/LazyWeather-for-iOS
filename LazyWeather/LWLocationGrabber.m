//
//  LWLocationGrabber.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

#import "LWLocationGrabber.h"

@import CoreLocation;

@interface LWLocationGrabber () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LWLocationGrabber

- (NSArray *)GetLatitudeAndLongitude
{

    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    return nil;
}


// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}



@end
