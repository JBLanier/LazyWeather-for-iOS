//
//  LWWeatherStore.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
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
        NSLog(@"forecasts: %@", _forecasts);
         NSLog(@"locatilty of foecasts: %@", _localityOfForecasts);
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
    self.forecasts = newForecasts;
    [self saveChanges];
    
}

- (void) setLocalityOfForecasts:(NSString *)localityOfForecasts{
    _localityOfForecasts = localityOfForecasts;
    [[LWWeatherUpdateManager sharedManager]locationUpdated];
    [self saveChanges];
    
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

- (BOOL)saveChanges {
    
    BOOL forecastsSaved = [NSKeyedArchiver archiveRootObject:self.forecasts
                                                      toFile:[self itemArchivePath]];
    NSLog(@"forecasts saved: %d",forecastsSaved);
    
    BOOL locationSaved = [NSKeyedArchiver archiveRootObject:self.localityOfForecasts
                                                     toFile:[self localityArchivePath]];
    NSLog(@"locality saved as: %@, success: %d",self.localityOfForecasts, locationSaved);
    
    return (locationSaved && forecastsSaved);
}


@end
