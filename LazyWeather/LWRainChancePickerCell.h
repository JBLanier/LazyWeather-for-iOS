//
//  PickerCell.h
//  LazyWeather
//
//  Created by JB on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSettingsViewController.h"

@interface LWRainChancePickerCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) LWSettingsViewController *tableVC;

@end
