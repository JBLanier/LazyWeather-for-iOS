//
//  LWWeatherUpdateManager.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
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

@property (nonatomic) BOOL UpdateWeatherAndNotificationsWithCompletionHandlerAllowed;

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
        self.UpdateWeatherAndNotificationsWithCompletionHandlerAllowed = YES;
    }
    //NSLog(@"WeatherUpdateManager Created!");
    return self;

}

/**********************************************************************************************/
# pragma mark - Primary Task: Update Weather and Notifications
/**********************************************************************************************/

- (void)UpdateWeatherAndNotificationsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //NSLog(@"Weatherupdatemangerupdatefunction called");
    
    if (!self.UpdateWeatherAndNotificationsWithCompletionHandlerAllowed) {
        //NSLog(@"Not proceding with Weatherupdatemangerupdatefunction, too soon since last time");
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    self.UpdateWeatherAndNotificationsWithCompletionHandlerAllowed = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(allowUpdateWeatherAndNotificationsWithCompletionHandler)
                                   userInfo:nil
                                    repeats:NO];
    
    if (self.updatesSubscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.updatesSubscriber weatherUpdateStarted];
        });
    }
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types ==
        UIUserNotificationTypeAlert) {
        //NSLog(@"Weather Update manager can confirm that correct User notification settings are registered");
    } else {
     //NSLog(@"Weather Update manager Sees that correct User notification settings are NOT registered!!!!!!!!");
    }
    
    [self.dataFetcher beginUpdatingWeatherWithCompletionHandler: ^(NSError *error) {
        
        if (error) {
            //NSLog(@"\nerror in callback block: %@ \n", error);
            
            if (self.updatesSubscriber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.updatesSubscriber weatherUpdateFailed];
                });
            }
    
            if (completionHandler) {
                 //NSLog(@"returning UIBackgroundFetchResultFailed");
                completionHandler(UIBackgroundFetchResultFailed);
            }
            
        } else {
            //NSLog(@"Date fetch process ended cleanly");
            //NSLog(@"updates subscriber : %@",self.updatesSubscriber);
            if (self.updatesSubscriber) {
                [self updateSubscriberDisplay];
            }
            if ([LWWeatherStore sharedStore].lastSetOfForecastsWasNewData) {
                [self scheduleNotifications];
                if (completionHandler) {
                    //NSLog(@"returning UIBackgroundFetchResultNewData");
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            } else {
                if (completionHandler) {
                    //NSLog(@"returning UIBackgroundFetchResultNoData");
                    completionHandler(UIBackgroundFetchResultNoData);
                }
            }
            
        }
    }];
}

- (void)scheduleNotifications {
    
    //NSLog(@"SCHEDULE NOTIFICATIONS CALLED");
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeAlert) {
        
        //NSLog(@"SCHEDULE NOTIFICATIONS QUITING BECAUSE NOTIFICATION SETTINGS ARE WRONG");
        return;
    }
    
    [self saveSchedulingTime];
    
    LWSettingsStore *settings = [LWSettingsStore sharedStore];
    LWWeatherStore *weather = [LWWeatherStore sharedStore];
    
    if (settings.notificationCondition == LWNotificationConditionDaily) {
        
        //NSLog(@"SCHEDULE NOTIFICATIONS SETTING UP FOR EVERY DAY");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            
            //NSLog(@"IN FOR LOOP");
            
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            
            /*
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *notificationDateSting = [formatter stringFromDate:notificationDate];
            //NSLog(@"%d NOTIFICATION DATE: %@", i, notificationDateSting);
            
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *currentDateSting = [formatter stringFromDate:[NSDate date]];
            //NSLog(@"%d CURRENT DATE: %@",i, currentDateSting);
            */
            
            
            NSDate *currentDate = [NSDate date];
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                //NSLog(@"PASSED EARLIER DATE CHECK");
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                //NSLog(@"Forcast = : %@", forecast);
                if (forecast && forecast.precipitationProbability != -100) {
                    //NSLog(@"PASSED GOOD DATA CHECK");
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        //NSLog(@"PASSED is notification there CHECK");
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                   
                        /*
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
                        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
                        NSString *notifDate = [formatter stringFromDate:notificationDate];
                        //NSLog(@"NOTIFICATION SCHDULED: %@ \nfire time = %@", notification, notifDate);
                        
                        */
                        
                    }
                }
            }
        }
    } else if ([LWSettingsStore sharedStore].notificationCondition == LWNotificationConditionRainOnly) {
        //NSLog(@"SCHEDULE NOTIFICATIONS SETTING UP FOR EVERY DAY");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:settings.notificationTime];
        NSInteger hour = timeComponents.hour;
        NSInteger minute = timeComponents.minute;
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        
        for (int i = 0; i < 8; i++) {
            
            //NSLog(@"IN FOR LOOP");
            
            dayComponent.day = i;
            NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            NSDate *notificationDate = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:nextDate options:0];
            
            /*
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *notificationDateSting = [formatter stringFromDate:notificationDate];
            //NSLog(@"%d NOTIFICATION DATE: %@", i, notificationDateSting);
            
            [formatter setDateFormat:@"MM-dd-yyy hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PMT"]];
            NSString *currentDateSting = [formatter stringFromDate:[NSDate date]];
            //NSLog(@"%d CURRENT DATE: %@",i, currentDateSting);
            */
            
            
            NSDate *currentDate = [NSDate date];
            if ([currentDate earlierDate: notificationDate] == currentDate) {
                //NSLog(@"PASSED EARLIER DATE CHECK");
                LWDailyForecast *forecast = [weather forecastForDay:notificationDate];
                //NSLog(@"Forcast = : %@", forecast);
                if (forecast && forecast.precipitationProbability != -100 && forecast.precipitationProbability >= settings.minimumPercentChanceWeatherForNotifcation) {
                    //NSLog(@"PASSED GOOD DATA CHECK");
                    UILocalNotification *notification = [[UILocalNotification alloc]init];
                    if (notification) {
                        //NSLog(@"PASSED is notification there CHECK");
                        notification.fireDate = notificationDate;
                        notification.timeZone = [NSTimeZone defaultTimeZone];
                        notification.alertBody =
                        [NSString stringWithFormat:@"%@ \nChance of Rain: %ld%@ \nHi: %ld Lo: %ld",
                         forecast.summary, (long)forecast.precipitationProbability,@"%%",(long)forecast.highTemperature, (long)forecast.lowTemperature];
                        
                        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
                        
                        
                        /*
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
                        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
                        NSString *notifDate = [formatter stringFromDate:notificationDate];
                        //NSLog(@"NOTIFICATION SCHDULED: %@ \nfire time = %@", notification, notifDate);
                        
                        */
                        
                    }
                }
            }
        }
    }
    
    

}

- (void)saveSchedulingTime {
    
    NSDate* updateDate = [NSDate date];
    NSArray *updateTimes = [[NSUserDefaults standardUserDefaults]arrayForKey:@"scheduleTimes"];
    if (updateTimes) {
        NSMutableArray *newUpdateTimes = [[NSMutableArray alloc] initWithArray:updateTimes];
        
        [newUpdateTimes addObject:updateDate];
        
        if (newUpdateTimes.count > 11) {
            [newUpdateTimes removeObjectAtIndex:0];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newUpdateTimes forKey:@"scheduleTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        NSArray *newUpdateTimes = @[updateDate];
        [[NSUserDefaults standardUserDefaults]setObject:newUpdateTimes forKey:@"scheduleTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)allowUpdateWeatherAndNotificationsWithCompletionHandler {
    _UpdateWeatherAndNotificationsWithCompletionHandlerAllowed = YES;
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
