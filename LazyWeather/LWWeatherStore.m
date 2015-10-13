//
//  LWWeatherStore.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWWeatherStore.h"
#import "LWDailyForecast.h"


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
        
    }
    return self;
}

/**********************************************************************************************/
#pragma mark - Accessors for weather
/**********************************************************************************************/

- (LWDailyForecast *)forecastForDay:(NSDate *)targetDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger targetDay = [gregorian component:(NSCalendarUnitDay) fromDate:targetDate];
    
    for (LWDailyForecast *f in self.forecasts) {
        NSInteger fday = [gregorian component:NSCalendarUnitDay fromDate:f.date];
        if (fday == targetDay) {
            return f;
        }
    }
    return nil;
}

- (void)setNewForecasts:(NSArray *)newForecasts
{
    self.forecasts = newForecasts;
}



@end
