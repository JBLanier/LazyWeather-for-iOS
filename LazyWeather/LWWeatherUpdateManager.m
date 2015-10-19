//
//  LWWeatherUpdateManager.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWWeatherUpdateManager.h"
#import "LWDataFetcher.h"
#import "LWWeatherStore.h"
#import "LWAppDelegate.h"
#import "LWHomeViewController.h"
#import "LWSettingsStore.h"
#import "LWDailyForecast.h"

@interface LWWeatherUpdateManager ()

@property (nonatomic, strong) LWDataFetcher *dataFetcher;

@property (nonatomic, weak) LWHomeViewController *updatesSubscriber;

@end

@implementation LWWeatherUpdateManager

/**********************************************************************************************/
# pragma mark - Initialization
/**********************************************************************************************/

+ (instancetype) sharedManager
{
    static LWWeatherUpdateManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initPrivate];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[LWWeatherUpdateManager sharedManager]"
                                 userInfo:nil];
    return nil;
    
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        self.dataFetcher = [[LWDataFetcher alloc] init];
    }
    
    return self;

}

/**********************************************************************************************/
# pragma mark - Primary Task: Update Weather and Notifications
/**********************************************************************************************/

- (void)UpdateWeatherAndNotificationsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (self.updatesSubscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.updatesSubscriber weatherUpdateStarted];
        });
    }
    
    [self.dataFetcher beginUpdatingWeatherWithCompletionHandler: ^(NSError *error) {
        
        if (error) {
            if (self.updatesSubscriber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.updatesSubscriber weatherUpdateFailed];
                });
            }
            
            if (completionHandler) {
                completionHandler(UIBackgroundFetchResultFailed);
            }
            
        } else {
            if (self.updatesSubscriber) {
                [self updateSubscriberDisplay];
            }
            if ([LWWeatherStore sharedStore].lastSetOfForecastsWasNewData) {
                [self scheduleNotifications];
                
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            } else {
                
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNoData);
                }
            }
            
        }
    }];
}

- (void)scheduleNotifications {
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeAlert) {
        return;
    }
    
    LWSettingsStore *settings = [LWSettingsStore sharedStore];
    LWWeatherStore *weather = [LWWeatherStore sharedStore];
    
    if (settings.notificationCondition == LWNotificationConditionDaily) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            NSDate *currentDate = [NSDate date];
            
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                if (forecast && forecast.precipitationProbability != -100) {
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                    }
                }
            }
        }
    } else if ([LWSettingsStore sharedStore].notificationCondition == LWNotificationConditionRainOnly) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            NSDate *currentDate = [NSDate date];
            
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                if (forecast && forecast.precipitationProbability != -100 && forecast.precipitationProbability >= settings.minimumPercentChanceWeatherForNotifcation) {
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                    }
                }
            }
        }
    }
    
    

}

/**********************************************************************************************/
# pragma mark - Keeping Home View Display in Sync
/**********************************************************************************************/

- (void)locationUpdated {
    if (self.updatesSubscriber) {
        [self updateSubscriberDisplay];
    }
}

- (void)setSubscriberToWeatherUpdates:(LWHomeViewController *)subscriber {
    self.updatesSubscriber = subscriber;
}

- (void)removeSubscriberToWeatherUpdates {
    self.updatesSubscriber = nil;
}

- (void)updateSubscriberDisplay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.updatesSubscriber updateWeatherInfo];
    });
}

@end
