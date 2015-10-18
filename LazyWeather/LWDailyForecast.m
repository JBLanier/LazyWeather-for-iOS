//
//  LWDailyForecast.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

// Done

#import "LWDailyForecast.h"
#import "LWSettingsStore.h"

@implementation LWDailyForecast

- (instancetype)initWithPrecipitationProbability:(NSInteger)prob
                                 HighTemperature:(NSInteger)hi
                                  LowTemperature:(NSInteger)lo
                                         Summary:(NSString *)summ
                                            Date:(NSDate *)date
{
    self = [super init];
    
    if (self) {
        _precipitationProbability = prob;
        _highTemperature = hi;
        _lowTemperature = lo;
        _summary = summ;
        _date = date;
    }
    return self;
}

- (NSInteger)highTemperature {
    if ([LWSettingsStore sharedStore].useCelciusDegrees) {
        double celsiusTemp = (5.0/9.0)*(_highTemperature-32.0);
        return (NSInteger)celsiusTemp;
    }
    return _highTemperature;
}

- (NSInteger)lowTemperature {
    if ([LWSettingsStore sharedStore].useCelciusDegrees) {
        double celsiusTemp = (5.0/9.0)*(_lowTemperature -32.0);
        return (NSInteger)celsiusTemp;
    }
    return _lowTemperature;
}

@end
