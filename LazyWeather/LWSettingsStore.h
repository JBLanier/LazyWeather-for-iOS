//
//  SettingsStore.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/15/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWSettingsStore : NSObject

+ (instancetype)sharedStore;

typedef NS_ENUM(NSInteger, LWNotificationCondition) {
    LWNotificationConditionNever     = 1,
    LWNotificationConditionRainOnly  = 2,
    LWNotificationConditionDaily     = 3,
    
};

@property (nonatomic) LWNotificationCondition notificationCondition;
@property (nonatomic) NSInteger minimumPercentChanceWeatherForNotifcation;
@property (nonatomic) NSDate *notificationTime;

@property (nonatomic) BOOL useCelciusDegrees;

- (NSString *) conditionText;
- (NSString *) percentText;
- (NSString *) timeText;

- (void) saveChanges;

@end
