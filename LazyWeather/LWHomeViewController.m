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
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowLabel;


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
   
    
    UIInterpolatingMotionEffect *motionEffect;
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                   type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];

    
    motionEffect.minimumRelativeValue = @-15;
    motionEffect.maximumRelativeValue = @15;
    [self.settingsButton addMotionEffect:motionEffect];
    
    motionEffect.minimumRelativeValue = @-20;
    motionEffect.maximumRelativeValue = @20;
    [self.todayLabel addMotionEffect:motionEffect];
    [self.tomorrowLabel addMotionEffect:motionEffect];
    
    
    motionEffect.minimumRelativeValue = @-6;
    motionEffect.maximumRelativeValue = @6;
    
    [self.badgeButton addMotionEffect:motionEffect];
    [self.todayView addMotionEffect:motionEffect];
    [self.tomorrowView addMotionEffect:motionEffect];
}

@end
