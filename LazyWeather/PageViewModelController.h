//
//  ModelController.h
//  LazyWeather
//
//  Created by JB on 10/15/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewModelController : NSObject <UIPageViewControllerDataSource>

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;

@end

