//
//  ModelController.m
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/15/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

#import "LWPageViewModelController.h"
#import "LWHomeViewController.h"
#import "LWSettingsViewController.h"

@interface LWPageViewModelController ()

@property (nonatomic, copy) NSArray *viewControllerRestorationIndentifiers;

@end

@implementation LWPageViewModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewControllerRestorationIndentifiers = @[@"HomeViewController",@"SettingsViewController"];
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
                                 storyboard:(UIStoryboard *)storyboard {
    // Create a new view controller and pass suitable data.
    if (index == 0) {
        LWHomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        return homeVC;
    } else if (index == 1) {
        LWSettingsViewController *settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        return settingsVC;
    } else {
        return nil;
    }
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    // Return the index of the given data view controller.
    NSString *identifier = viewController.restorationIdentifier;
    return [self.viewControllerRestorationIndentifiers indexOfObject:identifier];
    
}

/**********************************************************************************************/
#pragma mark - Page View Controller Data Source
/**********************************************************************************************/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 1) {
        LWHomeViewController *homeVC = [viewController.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        return homeVC;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 0) {
        LWSettingsViewController *settingsVC = [viewController.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        return settingsVC;
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


@end
