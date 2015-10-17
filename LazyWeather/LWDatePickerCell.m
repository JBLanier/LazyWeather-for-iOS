//
//  DatePickerCell.m
//  LazyWeather
//
//  Created by JB on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWDatePickerCell.h"

@interface LWDatePickerCell ()

@property (weak, nonatomic) IBOutlet UIView *bufferView;

@property (nonatomic) UIDatePicker *datePicker;
@end

@implementation LWDatePickerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect pickerFrame = CGRectMake(self.bufferView.bounds.origin.x,self.bufferView.bounds.origin.y,[UIScreen mainScreen].bounds.size.width,140);
    NSLog(@"\n\n\n\n\n\n WIDTH: %f",self.bufferView.bounds.size.width);
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [self.datePicker addTarget:self action:@selector(pickerChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.bufferView addSubview:self.datePicker];
    //[myPicker release];
    [self.contentView sizeToFit];
}

- (void)pickerChanged
{
    NSDate *date = self.datePicker.date;
    NSLog (@"%@", date);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
