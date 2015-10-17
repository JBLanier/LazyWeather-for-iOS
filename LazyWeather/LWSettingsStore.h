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

typedef NS_ENUM(NSInteger, LWNotificationCondition) {
    LWNotificationConditionDaily,
    LWNotificationConditionRainOnly,
    LWNotificationConditionNever
};

@property (nonatomic) LWNotificationCondition notificationCondition;
@property (nonatomic) int minimumPercentChanceWeatherForNotifcation;
@property (nonatomic) NSDate *notificationTime;

@property (nonatomic) BOOL useCelciusDegrees;

- (NSString *)conditionText;
- (NSString *)percentText;
- (NSString *)timeText;

@end
