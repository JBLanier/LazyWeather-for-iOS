//
//  SettingsStore.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/15/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
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
        _notificationCondition = [[NSUserDefaults standardUserDefaults]integerForKey:@"condition"];
        _minimumPercentChanceWeatherForNotifcation = [[NSUserDefaults standardUserDefaults]integerForKey:@"percent"];
        _notificationTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"time"];
        _useCelciusDegrees = [[NSUserDefaults standardUserDefaults]boolForKey:@"celsius"];
        
        if (!_notificationTime) {
            _notificationCondition = LWNotificationConditionRainOnly;

        }
        if (!_minimumPercentChanceWeatherForNotifcation) {
            _minimumPercentChanceWeatherForNotifcation = 30;
        }
        if (!_notificationTime) {
            
            NSDate *defaultDate = [NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *weekdayComponents =
            [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:defaultDate];
            [weekdayComponents setHour:6];
            [weekdayComponents setMinute:00];
            defaultDate = [gregorian dateFromComponents:weekdayComponents];
            
            _notificationTime = defaultDate;
        }
        
    }
    return self;
}

- (NSString *)conditionText {
    if (self.notificationCondition == LWNotificationConditionDaily) {
        return @"every day";
    } else if (self.notificationCondition == LWNotificationConditionRainOnly) {
        return @"only on days it might rain";
    }
    return @"never";
}

- (NSString *)percentText {
    return [NSString stringWithFormat:@"%ld%%",(long)[LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation];
}

- (NSString *)timeText {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *time = [formatter stringFromDate:self.notificationTime];
    return time;
}

- (NSString *)settingsArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return  [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (void) saveChanges {
    [[NSUserDefaults standardUserDefaults] setInteger:self.notificationCondition forKey:@"condition"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.minimumPercentChanceWeatherForNotifcation forKey:@"percent"];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationTime forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setBool:self.useCelciusDegrees forKey:@"celsius"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
