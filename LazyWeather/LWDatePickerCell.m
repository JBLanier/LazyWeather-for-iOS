//
//  DatePickerCell.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWDatePickerCell.h"
#import "LWSettingsStore.h"

@interface LWDatePickerCell ()

@property (weak, nonatomic) IBOutlet UIView *bufferView;

@property (nonatomic) UIDatePicker *datePicker;
@end

@implementation LWDatePickerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect pickerFrame = CGRectMake(self.bufferView.bounds.origin.x,self.bufferView.bounds.origin.y,[UIScreen mainScreen].bounds.size.width,120);
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [self.datePicker addTarget:self action:@selector(pickerChanged)
                             forControlEvents:UIControlEventValueChanged];
    UIColor *lwBlueColor = [UIColor colorWithRed:((float)((0x49CFEC & 0xFF0000) >> 16))/255.0 \
                                           green:((float)((0x49CFEC & 0x00FF00) >>  8))/255.0 \
                                            blue:((float)((0x49CFEC & 0x0000FF) >>  0))/255.0 \
                                           alpha:1.0];
    
    [self.datePicker setValue:lwBlueColor forKey:@"textColor"];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
   

    [self.bufferView addSubview:self.datePicker];
    //[myPicker release];
    [self.contentView sizeToFit];
}

- (void)pickerChanged
{
    NSDate *date = self.datePicker.date;
    [LWSettingsStore sharedStore].notificationTime = date;
    UITableViewCell *promptCell = [self.tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableVC.cellsInSectionZero.count-2 inSection:0]];
    UILabel* detail = (UILabel *)[promptCell.contentView viewWithTag:2];
    [detail setText:[[LWSettingsStore sharedStore] timeText]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
