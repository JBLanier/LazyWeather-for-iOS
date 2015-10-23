//
//  LWDailyForecast.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
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


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _precipitationProbability = [coder decodeIntegerForKey:@"percent"];
        _highTemperature = [coder decodeIntegerForKey:@"high"];
        _lowTemperature = [coder decodeIntegerForKey:@"low"];
        _summary = [coder decodeObjectForKey:@"summary"];
        _date = [coder decodeObjectForKey:@"date"];
        
    }
    return self;
}

- (NSInteger)highTemperature {
    if ([LWSettingsStore sharedStore].useCelciusDegrees) {
        double celsiusTemp = (5.0/9.0)*(_highTemperature - 32.0);
        NSLog(@"celsius %lf\nfarhrenheit:%ld", celsiusTemp, (long)_highTemperature);
        return (NSInteger)celsiusTemp;
    }
    return _highTemperature;
}

- (NSInteger)lowTemperature {
    if ([LWSettingsStore sharedStore].useCelciusDegrees) {
        double celsiusTemp = (5.0/9.0)*(_lowTemperature - 32.0);
        return (NSInteger)celsiusTemp;
    }
    return _lowTemperature;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger: _precipitationProbability forKey:@"percent"];
    [aCoder encodeInteger: _highTemperature forKey:@"high"];
    [aCoder encodeInteger: _lowTemperature forKey:@"low"];
    [aCoder encodeObject: _summary forKey:@"summary"];
    [aCoder encodeObject: _date forKey:@"date"];
}

@end
