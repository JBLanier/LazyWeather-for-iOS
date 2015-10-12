//
//  LWWeatherStore.h
//  LazyWeather
//
//  Created by JB on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWDailyForecast;

@interface LWWeatherStore : NSObject

+ (instancetype)sharedStore;

- (LWDailyForecast *)forecastForDay:(NSDate*)day;
- (void)addNewForecast:(LWDailyForecast *)newForecast;

@end
