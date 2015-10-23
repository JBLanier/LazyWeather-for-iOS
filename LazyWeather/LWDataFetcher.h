//
//  LWDataFetcher.h
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

// Done

#import <Foundation/Foundation.h>

@interface LWDataFetcher : NSObject

- (void)beginUpdatingWeatherWithCompletionHandler:(void (^)(NSError *))completionHandler;

@end
