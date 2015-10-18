//
//  LWConditionPickerCell.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/17/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWConditionPickerCell.h"
#import "LWSettingsStore.h"

@interface LWConditionPickerCell ()

@property (weak, nonatomic) IBOutlet UIView *bufferView;

@property (nonatomic) UIPickerView *pickerView;

@end

@implementation LWConditionPickerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect pickerFrame = CGRectMake(self.bufferView.bounds.origin.x,self.bufferView.bounds.origin.y,[UIScreen mainScreen].bounds.size.width,120);
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.bufferView.hidden = YES;
    [self performSelector:@selector(unHideBufferView) withObject:self afterDelay:0.2];
    
    LWNotificationCondition condition = [LWSettingsStore sharedStore].notificationCondition;
    NSInteger row;
    
    if (condition == LWNotificationConditionDaily) {
        row = 2;
    } else if (condition == LWNotificationConditionRainOnly) {
        row = 1;
    } else {
        row = 0;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
    
    [self.bufferView addSubview:self.pickerView];
    //[myPicker release];
    [self.contentView sizeToFit];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component != 0 || row > 10) {
        return;
    }
    NSLog(@"Row %@ Selected",[[self pickerView:thePickerView attributedTitleForRow:row forComponent:component]string]);
    if (row == 1) {
        [LWSettingsStore sharedStore].notificationCondition = LWNotificationConditionRainOnly;
    } else  if (row == 2){
        [LWSettingsStore sharedStore].notificationCondition = LWNotificationConditionDaily;
    } else {
        [LWSettingsStore sharedStore].notificationCondition = LWNotificationConditionNever;
    }
    UITableViewCell *promptCell = [self.tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel* title = (UILabel *)[promptCell.contentView viewWithTag:2];
    [title setText:[[LWSettingsStore sharedStore] conditionText]];
    [self.tableVC conditionPickerDidChangeSelection];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 3;
    }
    return 0;
    
}


-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component != 0) {
        return nil;
    }
    UIColor *lwBlueColor = [UIColor colorWithRed:((float)((0x49CFEC & 0xFF0000) >> 16))/255.0 \
                                           green:((float)((0x49CFEC & 0x00FF00) >>  8))/255.0 \
                                            blue:((float)((0x49CFEC & 0x0000FF) >>  0))/255.0 \
                                           alpha:1.0];
    
    switch (row) {
        case 0:
            return [[NSAttributedString alloc] initWithString:@"never" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 1:
            return [[NSAttributedString alloc] initWithString:@"only on days it might rain" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 2:
            return [[NSAttributedString alloc] initWithString:@"every day" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
               default:
            return nil;
            break;
    }
}

- (void)prepareForDeletion {
    self.bufferView.hidden = YES;
}

- (void)prepareForReuse {
    [self performSelector:@selector(unHideBufferView) withObject:self afterDelay:0.2];
    
    LWNotificationCondition condition = [LWSettingsStore sharedStore].notificationCondition;
    NSInteger row;
    
    if (condition == LWNotificationConditionDaily) {
        row = 2;
    } else if (condition == LWNotificationConditionRainOnly) {
        row = 1;
    } else {
        row = 0;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

- (void)unHideBufferView {
    self.bufferView.hidden = NO;
}

@end
