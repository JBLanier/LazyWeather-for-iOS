//
//  PickerCell.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWRainChancePickerCell.h"
#import "LWSettingsStore.h"

@interface LWRainChancePickerCell ()

@property (weak, nonatomic) IBOutlet UIView *bufferView;

@property (nonatomic) UIPickerView *pickerView;

@end

@implementation LWRainChancePickerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect pickerFrame = CGRectMake(self.bufferView.bounds.origin.x,self.bufferView.bounds.origin.y,[UIScreen mainScreen].bounds.size.width,120);
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];

    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.bufferView.hidden = YES;
    [self performSelector:@selector(unHideBufferView) withObject:self afterDelay:0.2];
    
    NSInteger row = [LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation / 10;
    [self.pickerView selectRow:row inComponent:0 animated:NO];
    
    [self.bufferView addSubview:self.pickerView];
    //[myPicker release];
    [self.contentView sizeToFit];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component != 0 || row > 10) {
        return;
    }
    if (row == 0) {
        [LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation = 5;
    } else {
        [LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation = row * 10.0;
    }
    UITableViewCell *promptCell = [self.tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel* detail = (UILabel *)[promptCell.contentView viewWithTag:2];
    [detail setText:[[LWSettingsStore sharedStore] percentText]];
    
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
        return 11;
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
            return [[NSAttributedString alloc] initWithString:@"5%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 1:
            return [[NSAttributedString alloc] initWithString:@"10%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 2:
            return [[NSAttributedString alloc] initWithString:@"20%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 3:
            return [[NSAttributedString alloc] initWithString:@"30%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 4:
            return [[NSAttributedString alloc] initWithString:@"40%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 5:
            return [[NSAttributedString alloc] initWithString:@"50%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 6:
            return [[NSAttributedString alloc] initWithString:@"60%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 7:
            return [[NSAttributedString alloc] initWithString:@"70%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 8:
            return [[NSAttributedString alloc] initWithString:@"80%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 9:
            return [[NSAttributedString alloc] initWithString:@"90%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
            break;
        case 10:
            return [[NSAttributedString alloc] initWithString:@"100%" attributes:@{NSForegroundColorAttributeName:lwBlueColor}];
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
    
    NSInteger row = [LWSettingsStore sharedStore].minimumPercentChanceWeatherForNotifcation / 10;
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

- (void)unHideBufferView {
    self.bufferView.hidden = NO;
}


@end
