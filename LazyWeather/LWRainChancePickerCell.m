//
//  PickerCell.m
//  LazyWeather
//
//  Created by JB on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWRainChancePickerCell.h"

@implementation LWRainChancePickerCell

- (void)awakeFromNib {
    // Initialization code
     [self.contentView sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
