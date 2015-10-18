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
# pragma mark - Primary Task
/**********************************************************************************************/

- (void)UpdateWeatherAndNotificationsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Weatherupdatemangerupdatefunction called");
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings] ==
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]) {
        NSLog(@"Weather Update manager can confirm that correct User notification settings are registered");
        return;////
    }
    
     NSLog(@"Weather Update manager Sees that correct User notification settings are NOT registered!!!!!!!!");
    
    [self.dataFetcher beginUpdatingWeatherWithCompletionHandler: ^(NSError *error) {
        
        if (error) {
            NSLog(@"error in callback block");
        } else {
            NSLog(@"Date fetch process ended cleanly");
            NSLog(@"updates subscriber : %@",self.updatesSubscriber);
            if (self.updatesSubscriber) {
                [self updateSubscriberDisplay];
            }
        }
    }];
}

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
