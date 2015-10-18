//
//  LWSettingsViewController.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/16/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWSettingsViewController.h"
#import "LWSettingsStore.h"
#import "LWDatePickerCell.h"
#import "LWConditionPickerCell.h"
#import "LWRainChancePickerCell.h"
#import "LWUnitsPromptCell.h"

@interface LWSettingsViewController ()

@property (nonatomic, readonly) UIColor *lwBlueColor;

@property (nonatomic) BOOL isEditingCondition;
@property (nonatomic) BOOL isEditingRainChance;
@property (nonatomic) BOOL isEditingTime;

@end

@implementation LWSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.isEditingCondition = NO;
    self.isEditingRainChance = NO;
    self.isEditingTime = NO;
    [self updateSectionZeroContent];
    self.cellsInSectionOne  = [[NSMutableArray alloc] initWithArray:@[@"UnitsPromptCell"]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self updateSectionZeroContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.cellsInSectionZero.count;
    } else if (section == 1) {
        return self.cellsInSectionOne.count;
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell* cell = nil;
    
    if ((section == 0 && row < self.cellsInSectionZero.count) || (section == 1 && row <self.cellsInSectionOne.count)) {
        
        NSString* identifier = ( section == 0? self.cellsInSectionZero[row] : self.cellsInSectionOne[row]);
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if        ([identifier isEqual:@"ConditionPromptCell" ]) {
            UILabel* label = (UILabel *)[cell.contentView viewWithTag:1];
            [label setText:@"Notify Me"];
            
            UILabel* detail = (UILabel *)[cell.contentView viewWithTag:2];
            [detail setText:[[LWSettingsStore sharedStore]conditionText]];
            
        } else if ([identifier isEqual:@"RainChancePromptCell"]) {
            UILabel* title = (UILabel *)[cell.contentView viewWithTag:1];
            [title setText:@"With a Minimum Chance of"];
            
            UILabel* detail = (UILabel *)[cell.contentView viewWithTag:2];
            [detail setText:[[LWSettingsStore sharedStore] percentText]];
            
        } else if ([identifier isEqual:@"TimePromptCell"      ]) {
            UILabel* title = (UILabel *)[cell.contentView viewWithTag:1];
            [title setText:@"Notify Me At"];
            
            UILabel* detail = (UILabel *)[cell.contentView viewWithTag:2];
            [detail setText:[[LWSettingsStore sharedStore] timeText]];
        } else if ([identifier isEqual:@"ConditionPickerCell" ]) {
            LWConditionPickerCell *pickerCell = (LWConditionPickerCell *)cell;
            pickerCell.tableVC = self;
        } else if ([identifier isEqual:@"RainChancePickerCell"]) {
            LWRainChancePickerCell *rainPickerCell = (LWRainChancePickerCell *)cell;
            rainPickerCell.tableVC = self;
        } else if ([identifier isEqual:@"TimePickerCell"      ]) {
            LWDatePickerCell *datePickerCell = (LWDatePickerCell *)cell;
            datePickerCell.tableVC = self;
        } else if ([identifier isEqual:@"UnitsPromptCell"     ]) {
            
        }
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"When do you want be notifed about the weather?";
    }
    else if (section == 1) {
        return @"Units";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]] && section == 0){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if ((section == 0 && row < self.cellsInSectionZero.count) || (section == 1 && row <self.cellsInSectionOne.count)) {
        
        NSString* identifier = ( section == 0 ? self.cellsInSectionZero[row] : self.cellsInSectionOne[row]);
        if        ([identifier isEqual:@"ConditionPromptCell" ]) {
            self.isEditingCondition = !self.isEditingCondition;
            
        } else if ([identifier isEqual:@"RainChancePromptCell"]) {
            self.isEditingRainChance = !self.isEditingRainChance;
            
        } else if ([identifier isEqual:@"TimePromptCell"]) {
            self.isEditingTime = !self.isEditingTime;
            
        } else {
            [self updateSectionZeroContent];
        }
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIColor *)lwBlueColor
{
    return [UIColor colorWithRed:((float)((0x49CFEC & 0xFF0000) >> 16))/255.0 \
                           green:((float)((0x49CFEC & 0x00FF00) >>  8))/255.0 \
                            blue:((float)((0x49CFEC & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

- (void) updateSectionZeroContent {
    self.isEditingCondition = NO;
    self.isEditingRainChance = NO;
    self.isEditingTime = NO;
    
    LWSettingsStore *settings = [LWSettingsStore sharedStore];
    if (!self.cellsInSectionZero) {
        self.cellsInSectionZero = [[NSMutableArray alloc] initWithArray:@[@"ConditionPromptCell"]];
    }
    
    NSMutableArray *cells = self.cellsInSectionZero;
    /*UITableViewCell *promptCell =  */ [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    /*UILabel* title = (UILabel *)[promptCell.contentView viewWithTag:2];
    [title setText:[[LWSettingsStore sharedStore] conditionText]];*/
    
    if (settings.notificationCondition == LWNotificationConditionNever) {
        if ([cells containsObject:@"RainChancePromptCell"]) {
            [cells removeObjectAtIndex:1];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        if ([cells containsObject:@"TimePromptCell"]) {
            NSInteger row = [self.cellsInSectionZero indexOfObject:@"TimePromptCell"];
            [cells removeObjectAtIndex:row];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
    } else if (settings.notificationCondition == LWNotificationConditionDaily) {
        if ([cells containsObject:@"RainChancePromptCell"]) {
            [cells removeObjectAtIndex:1];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        if (![cells containsObject:@"TimePromptCell"]) {
            [cells insertObject:@"TimePromptCell" atIndex:1];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
    } else {
        if (![cells containsObject:@"RainChancePromptCell"]) {
            [cells insertObject:@"RainChancePromptCell" atIndex:1];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        if (![cells containsObject:@"TimePromptCell"]) {
            [cells insertObject:@"TimePromptCell" atIndex:2];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}

- (void)setIsEditingCondition:(BOOL)isEditingCondition {
    if (isEditingCondition == _isEditingCondition) {
        return;
    }
    if (isEditingCondition) {
        self.isEditingRainChance = NO;
        self.isEditingTime = NO;
        [self.cellsInSectionZero insertObject:@"ConditionPickerCell" atIndex:1];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        _isEditingCondition = YES;
    } else {
        [self.cellsInSectionZero removeObject:@"ConditionPickerCell"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        LWConditionPickerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForDeletion];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        /*cell = */[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       /* UILabel* title = (UILabel *)[cell.contentView viewWithTag:2];
        [title setText:[[LWSettingsStore sharedStore] conditionText]]; */
        
        _isEditingCondition = NO;
        [self updateSectionZeroContent];
    }
}

- (void)setIsEditingRainChance:(BOOL)isEditingRainChance {
    if (isEditingRainChance == _isEditingRainChance) {
        return;
    }
    if (isEditingRainChance) {
        self.isEditingCondition = NO;
        self.isEditingTime = NO;
        [self.cellsInSectionZero insertObject:@"RainChancePickerCell" atIndex:2];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        _isEditingRainChance = YES;
    } else {
        [self.cellsInSectionZero removeObject:@"RainChancePickerCell"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        LWRainChancePickerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForDeletion];

        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
       /* cell = */[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
      /*  UILabel* title = (UILabel *)[cell.contentView viewWithTag:2];
        [title setText:[[LWSettingsStore sharedStore] percentText]]; */
        
        _isEditingRainChance = NO;
    }
}

- (void)setIsEditingTime:(BOOL)isEditingTime {
    if (isEditingTime == _isEditingTime) {
        return;
    }
    if (isEditingTime) {
        self.isEditingCondition = NO;
        self.isEditingRainChance = NO;
        NSInteger row = self.cellsInSectionZero.count;
        [self.cellsInSectionZero insertObject:@"TimePickerCell" atIndex:row];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        _isEditingTime= YES;
    } else {
        NSInteger row = [self.cellsInSectionZero indexOfObject:@"TimePickerCell"];
        [self.cellsInSectionZero removeObject:@"TimePickerCell"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        LWDatePickerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForDeletion];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
       /* cell = */[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0]];
        /*UILabel* title = (UILabel *)[cell.contentView viewWithTag:2];
        [title setText:[[LWSettingsStore sharedStore] timeText]];*/
        
        _isEditingTime = NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if ([self.cellsInSectionZero[row]  isEqual: @"ConditionPickerCell"] || [self.cellsInSectionZero[row]  isEqual: @"TimePickerCell"]
                ||  [self.cellsInSectionZero[row]  isEqual: @"RainChancePickerCell"]) {
            return 120.0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void) conditionPickerDidChangeSelection {
    if (!self.isEditingCondition) {
        [self updateSectionZeroContent];
    }
}

@end
