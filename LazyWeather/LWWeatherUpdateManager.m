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
    NSLog(@"Weatherupdatemangerupdatefunction called");
    
    if (self.updatesSubscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.updatesSubscriber weatherUpdateStarted];
        });
    }
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types ==
        UIUserNotificationTypeAlert) {
        NSLog(@"Weather Update manager can confirm that correct User notification settings are registered");
    } else {
     NSLog(@"Weather Update manager Sees that correct User notification settings are NOT registered!!!!!!!!");
    }
    
    [self.dataFetcher beginUpdatingWeatherWithCompletionHandler: ^(NSError *error) {
        
        if (error) {
            NSLog(@"error in callback block");
            
            if (self.updatesSubscriber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.updatesSubscriber weatherUpdateFailed];
                });
            }
            NSLog(@"returning UIBackgroundFetchResultFailed");
            if (completionHandler) {
                completionHandler(UIBackgroundFetchResultFailed);
            }
            
        } else {
            NSLog(@"Date fetch process ended cleanly");
            NSLog(@"updates subscriber : %@",self.updatesSubscriber);
            if (self.updatesSubscriber) {
                [self updateSubscriberDisplay];
            }
            if ([LWWeatherStore sharedStore].lastSetOfForecastsWasNewData) {
                [self scheduleNotifications];
                NSLog(@"returning UIBackgroundFetchResultNewData");
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            } else {
                NSLog(@"returning UIBackgroundFetchResultNoData");
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNoData);
                }
            }
            
        }
    }];
}

- (void)scheduleNotifications {
    
    NSLog(@"SCHEDULE NOTIFICATIONS CALLED");
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeAlert) {
        
        NSLog(@"SCHEDULE NOTIFICATIONS QUITING BECAUSE NOTIFICATION SETTINGS ARE WRONG");
        return;
    }
    
    LWSettingsStore *settings = [LWSettingsStore sharedStore];
    LWWeatherStore *weather = [LWWeatherStore sharedStore];
    
    NSLog(@"NOTIFICATION CONDITION: %ld, should be %ld", (long)settings.notificationCondition, (long)LWNotificationConditionDaily);
    if (settings.notificationCondition == LWNotificationConditionDaily) {
        
        NSLog(@"SCHEDULE NOTIFICATIONS SETTING UP FOR EVERY DAY");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            
            NSLog(@"IN FOR LOOP");
            
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            
            //////
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *notificationDateSting = [formatter stringFromDate:notificationDate];
            NSLog(@"%d NOTIFICATION DATE: %@", i, notificationDateSting);
            
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *currentDateSting = [formatter stringFromDate:[NSDate date]];
            NSLog(@"%d CURRENT DATE: %@",i, currentDateSting);
            //////
            
            
            NSDate *currentDate = [NSDate date];
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                NSLog(@"PASSED EARLIER DATE CHECK");
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                if (forecast && forecast.precipitationProbability != -100) {
                    NSLog(@"PASSED GOOD DATA CHECK");
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        NSLog(@"PASSED is notification there CHECK");
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                        //// delete
                        // we're creating a string of the date so we can log the time the notif is supposed to fire
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
                        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
                        NSString *notifDate = [formatter stringFromDate:notificationDate];
                        NSLog(@"NOTIFICATION SCHDULED: %@ \nfire time = %@", notification, notifDate);
                        
                        /////////
                        
                    }
                }
            }
        }
    } else if ([LWSettingsStore sharedStore].notificationCondition == LWNotificationConditionRainOnly) {
        NSLog(@"SCHEDULE NOTIFICATIONS SETTING UP FOR EVERY DAY");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            
            NSLog(@"IN FOR LOOP");
            
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            
            //////
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *notificationDateSting = [formatter stringFromDate:notificationDate];
            NSLog(@"%d NOTIFICATION DATE: %@", i, notificationDateSting);
            
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *currentDateSting = [formatter stringFromDate:[NSDate date]];
            NSLog(@"%d CURRENT DATE: %@",i, currentDateSting);
            //////
            
            
            NSDate *currentDate = [NSDate date];
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                NSLog(@"PASSED EARLIER DATE CHECK");
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                if (forecast && forecast.precipitationProbability != -100 && forecast.precipitationProbability >= settings.minimumPercentChanceWeatherForNotifcation) {
                    NSLog(@"PASSED GOOD DATA CHECK");
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        NSLog(@"PASSED is notification there CHECK");
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                        //// delete
                        // we're creating a string of the date so we can log the time the notif is supposed to fire
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
                        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
                        NSString *notifDate = [formatter stringFromDate:notificationDate];
                        NSLog(@"NOTIFICATION SCHDULED: %@ \nfire time = %@", notification, notifDate);
                        
                        /////////
                        
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
