//
//  SettingsStore.h
//  LazyWeather
//
//  Created by JB on 10/15/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWSettingsStore : NSObject

+ (instancetype)sharedStore;

typedef NS_ENUM(NSInteger, LWNotificationFrequency) {
    LWNotificationFrequencyDaily,
    LWNotificationFrequencyRainOnly,
    LWNotificationFrequencySevereOnly,
    LWNotificationFrequencyNever
};

@property (nonatomic) LWNotificationFrequency notificationFrequency;
@property (nonatomic) int minimumPercentChanceWeatherForNotifcation;
@property (nonatomic) BOOL useCelciusDegrees;
@property (nonatomic) NSDate *notificationTime;

@end
