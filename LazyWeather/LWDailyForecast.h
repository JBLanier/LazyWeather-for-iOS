//
//  LWDailyForecast.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

// Done

#import <Foundation/Foundation.h>

@interface LWDailyForecast : NSObject <NSCoding>

- (instancetype)initWithPrecipitationProbability:(NSInteger)prob
                                 HighTemperature:(NSInteger)hi
                                  LowTemperature:(NSInteger)lo
                                         Summary:(NSString *)summ
                                            Date:(NSDate *)date;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSInteger precipitationProbability;
@property (nonatomic) NSInteger highTemperature;
@property (nonatomic) NSInteger lowTemperature;
@property (nonatomic, copy) NSString* summary;

@end
