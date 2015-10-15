//
//  LWDailyForecast.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

// Done

#import "LWDailyForecast.h"

@implementation LWDailyForecast

- (instancetype)initWithPrecipitationProbability:(NSNumber *)prob
                                 HighTemperature:(NSNumber *)hi
                                  LowTemperature:(NSNumber *)lo
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

@end
