//
//  LWSettingsViewController.h
//  LazyWeather
//
//  Created by JB on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWSettingsViewController : UITableViewController <UITableViewDataSource, UITabBarControllerDelegate>

- (void) evaluateSettingsAndSetSectionZeroContentsAccordingly;

@end
