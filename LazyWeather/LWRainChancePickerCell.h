//
//  PickerCell.h
//  WeatherLazy
//
//  Created by John Lanier and Arthur Pan on 10/16/15.
//  Copyright © 2015 WeatherLazy Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSettingsViewController.h"

@interface LWRainChancePickerCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) LWSettingsViewController *tableVC;

- (void)prepareForDeletion;

@end
