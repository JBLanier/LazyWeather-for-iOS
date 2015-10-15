//
//  ModelController.m
//  LazyWeather
//
//  Created by JB on 10/15/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "PageViewModelController.h"
#import "LWHomeViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface PageViewModelController ()

@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation PageViewModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (index > 1) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    if (index == 0) {
        LWHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        return homeVC;
    }
    else {
        return nil; // do else if here for settingsview controller !!!!!!! ////////
    }
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    if ([viewController isKindOfClass:[LWHomeViewController class]]) {
        return 0;
    } else {
        return 1; // add stuff for settings VC HERE!!!!!!!!!
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
