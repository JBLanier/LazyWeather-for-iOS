//
//  LWConditionPickerCell.h
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/17/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSettingsViewController.h"

@interface LWConditionPickerCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) LWSettingsViewController *tableVC;

@end
