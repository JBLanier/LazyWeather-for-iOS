//
//  SettingsStore.m
//  LazyWeather
//
//  Created by JB on 10/15/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWSettingsStore.h"

@implementation LWSettingsStore

+ (instancetype)sharedStore {
    static LWSettingsStore* sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[SettingsStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _notificationCondition = LWNotificationConditionRainOnly;
        _minimumPercentChanceWeatherForNotifcation = 30;
        _notificationTime = [NSDate date];
    }
    return self;
}

- (NSString *)conditionText {
    if (self.notificationCondition == LWNotificationConditionDaily) {
        return @"Every Day";
    } else if (self.notificationCondition == LWNotificationConditionRainOnly) {
        return @"Only if it Will Rain";
    }
    return @"Never";
}

- (NSString *)percentText {
    return [NSString stringWithFormat:@"%d%%",[LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation];
}

- (NSString *)timeText {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *time = [formatter stringFromDate:self.notificationTime];
    return time;
}



@end
