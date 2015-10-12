//
//  LWDailyForecast.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

// Done

#import <Foundation/Foundation.h>

@interface LWDailyForecast : NSObject

- (instancetype)initWithPrecipitationProbability:(NSNumber *)prob
                                 HighTemperature:(NSNumber *)hi
                                  LowTemperature:(NSNumber *)lo
                                         Summary:(NSString *)summ
                                            Date:(NSDate *)date;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSNumber *precipitationProbability;
@property (nonatomic, readonly) NSNumber *highTemperature;
@property (nonatomic, readonly) NSNumber *lowTemperature;
@property (nonatomic, copy, readonly) NSString* summary;

@end
