//
//  LWWeatherStore.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

#import "LWWeatherStore.h"
#import "LWDailyForecast.h"
#import "LWWeatherUpdateManager.h"


@interface LWWeatherStore ()

@property (nonatomic, copy)NSArray* forecasts;

@end

@implementation LWWeatherStore

/**********************************************************************************************/
#pragma marks - Initialization
/**********************************************************************************************/

+ (instancetype)sharedStore {
    static LWWeatherStore* sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[LWWeatherStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _forecasts = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
        _localityOfForecasts = [NSKeyedUnarchiver unarchiveObjectWithFile:[self localityArchivePath]];
        ////NSLog(@"forecasts: %@", _forecasts);
         //NSLog(@"locatilty of foecasts: %@", _localityOfForecasts);
        if (!_forecasts) {
            LWDailyForecast* todayPlaceholder = [[LWDailyForecast alloc] initWithPrecipitationProbability:-100
                                                                                          HighTemperature:-100
                                                                                           LowTemperature:-100
                                                                                                  Summary:@"No weather information yet!"
                                                                                                     Date:[NSDate date]];
            
            LWDailyForecast* tomorrowPlaceholder = [[LWDailyForecast alloc] initWithPrecipitationProbability:-100
                                                                                             HighTemperature:-100
                                                                                              LowTemperature:-100
                                                                                                     Summary:@""
                                                                                                        Date:[NSDate dateWithTimeIntervalSinceNow:86400]];
            _forecasts = @[todayPlaceholder,tomorrowPlaceholder];
        }
    }
    return self;
}

/**********************************************************************************************/
#pragma mark - Accessors for weather
/**********************************************************************************************/

- (LWDailyForecast *)forecastForDay:(NSDate *)targetDate
{
    if (self.forecasts) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger targetDay = [gregorian component:(NSCalendarUnitDay) fromDate:targetDate];
        
        for (LWDailyForecast *f in self.forecasts) {
            NSInteger fday = [gregorian component:NSCalendarUnitDay fromDate:f.date];
            if (fday == targetDay) {
                return f;
            }
        }
    }
    return nil;
}

- (void)setNewForecasts:(NSArray *)newForecasts {
    
    [self saveUpdateTime];
    
    
    // This comparison does not work, likely always returns false, must change;
    if ([self areForecastArraysEqual:self.forecasts and:newForecasts]) {
        //NSLog(@"NEW FORECASTS COMPARED AND ARE THE SAME DATA AS BEFORE");
        _lastSetOfForecastsWasNewData = NO;
        
    } else {
         //NSLog(@"NEW FORECASTS COMPARED AND ARE NEW DATA");
        self.forecasts = newForecasts;
        
        _lastSetOfForecastsWasNewData = YES;
    }
    
    LWDailyForecast *todayForecast = [self forecastForDay:[NSDate date]];
    if (todayForecast) {
        todayForecast.date = [NSDate date];
    }
    [self saveForecastChanges];
}

- (NSDate *)lastUpdateDate {
    LWDailyForecast *updateDateForecast = self.forecasts[0];
    NSDate* updateDate = updateDateForecast.date;
    return updateDate;
}

- (NSString *)lastUpdateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
    NSString *returnString = [NSString stringWithFormat:@"%@",
                              [formatter stringFromDate:self.lastUpdateDate]];
    return returnString;
}

- (void)saveUpdateTime {
    
    LWDailyForecast *updateDateForecast = self.forecasts[0];
    NSDate* updateDate = updateDateForecast.date;
    
    NSArray *updateTimes = [[NSUserDefaults standardUserDefaults]arrayForKey:@"updateTimes"];
    if (updateTimes) {
        NSMutableArray *newUpdateTimes = [[NSMutableArray alloc] initWithArray:updateTimes];
        
        [newUpdateTimes addObject:updateDate];
        
        if (newUpdateTimes.count > 11) {
            [newUpdateTimes removeObjectAtIndex:0];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newUpdateTimes forKey:@"updateTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        NSArray *newUpdateTimes = @[updateDate];
        [[NSUserDefaults standardUserDefaults]setObject:newUpdateTimes forKey:@"updateTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (void) setLocalityOfForecasts:(NSString *)localityOfForecasts{
    _localityOfForecasts = localityOfForecasts;
    [[LWWeatherUpdateManager sharedManager]locationUpdated];
    [self saveLocationChanges];
    
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return  [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (NSString *)localityArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return  [documentDirectory stringByAppendingPathComponent:@"locality.archive"];
}

- (BOOL)saveForecastChanges {
    
    BOOL forecastsSaved = [NSKeyedArchiver archiveRootObject:self.forecasts
                                                      toFile:[self itemArchivePath]];
    //NSLog(@"forecasts saved: %d",forecastsSaved);
    
    return forecastsSaved;
}

- (BOOL)saveLocationChanges {
    BOOL locationSaved = [NSKeyedArchiver archiveRootObject:self.localityOfForecasts
                                                     toFile:[self localityArchivePath]];
    //NSLog(@"locality saved as: %@, success: %d",self.localityOfForecasts, locationSaved);
    
    return locationSaved;
}

- (BOOL)areForecastArraysEqual:(NSArray *)array1 and:(NSArray *)array2 {
    for (int i = 0; i < 8; i++) {
        LWDailyForecast *forecast1 = array1[i];
        LWDailyForecast *forecast2 = array2[i];
        NSString *summary1 = forecast1.summary;
        NSString *summary2 = forecast2.summary;
        
        if (![summary1 isEqualToString:summary2]) {
            return NO;
        }
        
    }
    return YES;
}

@end
