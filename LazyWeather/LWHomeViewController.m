//
//  LWHomeViewController.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//


#import "LWHomeViewController.h"

@interface LWHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *badgeButton;

@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UIView *tomorrowView;

@property (weak, nonatomic) IBOutlet UILabel *todayViewRainChance;
@property (weak, nonatomic) IBOutlet UILabel *todayViewHigh;
@property (weak, nonatomic) IBOutlet UILabel *todayViewLow;
@property (weak, nonatomic) IBOutlet UILabel *todayViewDay;
@property (weak, nonatomic) IBOutlet UILabel *todayViewSummary;

@property (weak, nonatomic) IBOutlet UILabel *tomorrowViewRainChance;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowViewHigh;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowViewLow;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowViewDay;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowViewSummary;

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
   
    UIInterpolatingMotionEffect *lesserMotionEffect;
    lesserMotionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x"
                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    lesserMotionEffect.minimumRelativeValue = @(-2);
    lesserMotionEffect.maximumRelativeValue = @(2);
    
    [self.todayViewDay              addMotionEffect:lesserMotionEffect];
    [self.tomorrowViewDay           addMotionEffect:lesserMotionEffect];
    [self.badgeButton               addMotionEffect:lesserMotionEffect];
    
    lesserMotionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y"
                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    lesserMotionEffect.minimumRelativeValue = @(-2);
    lesserMotionEffect.maximumRelativeValue = @(2);
    
    
    [self.todayViewDay              addMotionEffect:lesserMotionEffect];
    [self.tomorrowViewDay           addMotionEffect:lesserMotionEffect];
    [self.badgeButton               addMotionEffect:lesserMotionEffect];
    
    
    UIInterpolatingMotionEffect *greaterMotionEffect;
    greaterMotionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x"
                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    greaterMotionEffect.minimumRelativeValue = @(-7);
    greaterMotionEffect.maximumRelativeValue = @(7);
    
    
    
    [self.todayViewRainChance       addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewRainChance    addMotionEffect:greaterMotionEffect];
    [self.todayViewHigh             addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewHigh          addMotionEffect:greaterMotionEffect];
    [self.todayViewLow              addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewLow           addMotionEffect:greaterMotionEffect];
    [self.todayViewSummary          addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewSummary       addMotionEffect:greaterMotionEffect];
    [self.settingsButton            addMotionEffect:greaterMotionEffect];
    
    greaterMotionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y"
                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    greaterMotionEffect.minimumRelativeValue = @(-7);
    greaterMotionEffect.maximumRelativeValue = @(7);
    
    
    
    [self.todayViewRainChance       addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewRainChance    addMotionEffect:greaterMotionEffect];
    [self.todayViewHigh             addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewHigh          addMotionEffect:greaterMotionEffect];
    [self.todayViewLow              addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewLow           addMotionEffect:greaterMotionEffect];
    [self.todayViewSummary          addMotionEffect:greaterMotionEffect];
    [self.tomorrowViewSummary       addMotionEffect:greaterMotionEffect];
    [self.settingsButton            addMotionEffect:greaterMotionEffect];
}

@end
