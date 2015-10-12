//
//  LWDailyForecast.h
//  LazyWeather
//
//  Created by JB on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

// Done

#import <Foundation/Foundation.h>

@interface LWDailyForecast : NSObject

- (instancetype)initWithPrecipitationProbability:(int)prob
                                 HighTemperature:(int)hi
                                  LowTemperature:(int)lo
                                         Summary:(NSString *)summ
                                            Date:(NSDate *)date;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) int precipitationProbability;
@property (nonatomic, readonly) int highTemperature;
@property (nonatomic, readonly) int lowTemperature;
@property (nonatomic, copy, readonly) NSString* summary;


@end
