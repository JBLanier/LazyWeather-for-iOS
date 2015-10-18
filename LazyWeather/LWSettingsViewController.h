//
//  LWSettingsViewController.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWSettingsViewController : UITableViewController <UITableViewDataSource, UITabBarControllerDelegate>

- (void) evaluateSettingsAndSetSectionZeroContentsAccordingly;

@property (nonatomic, strong) NSMutableArray *cellsInSectionZero;
@property (nonatomic, strong) NSMutableArray *cellsInSectionOne;

@end
