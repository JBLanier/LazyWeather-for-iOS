//
//  LWWeatherStore.m
//  LazyWeather
//
//  Created by JB on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWWeatherStore.h"
#import "LWDailyForecast.h"


@interface LWWeatherStore ()

@property (nonatomic, copy)NSMutableArray* forecasts;

@end

@implementation LWWeatherStore

#pragma marks - Initialization

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

#pragma mark - Accessors for weather

- (void)addNewForecast:(LWDailyForecast *)newForecast
{
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* newForecastComponents = [cal components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:newForecast.date];
    
    LWDailyForecast *replaceForecast = nil;
    LWDailyForecast *deleteForcast = nil;
    
    /*
    
    for (LWDailyForecast* f in self.forecasts) {
        
        
        
        if ([f.date isEqualToDate:newForecast.date]) {
            replaceForecast = f;
        }
        if () {
            <#statements#>
        }
    }
    
    if (replaceForecast) {
        replaceForecast = newForecast;
    } else {
        [self.forecasts addObject:newForecast];
    }
     
     */
}


@end
