//
//  LWUnitsPromptCell.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/17/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWUnitsPromptCell.h"
#import "LWSettingsStore.h"

@implementation LWUnitsPromptCell

- (IBAction)celsiusSwitch:(id)sender {
    [LWSettingsStore sharedStore].useCelciusDegrees = ![LWSettingsStore sharedStore].useCelciusDegrees;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
