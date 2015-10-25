//
//  LWWeatherUpdateManager.h
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LWHomeViewController;

@interface LWWeatherUpdateManager : NSObject

+(instancetype)sharedManager;

- (void)UpdateWeatherAndNotificationsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)locationUpdated;

- (void)setSubscriberToWeatherUpdates:(LWHomeViewController *)subscriber;
- (void)removeSubscriberToWeatherUpdates;

- (void)scheduleNotifications;

@end
