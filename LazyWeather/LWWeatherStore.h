//
//  LWWeatherStore.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWDailyForecast;

@interface LWWeatherStore : NSObject

+ (instancetype)sharedStore;

- (LWDailyForecast *)forecastForDay:(NSDate*)date;
- (void)setNewForecasts:(NSArray *)newForecasts;

@property (nonatomic, copy) NSString *localityOfForecasts;
@property (nonatomic, readonly) BOOL lastSetOfForecastsWasNewData;


@end
