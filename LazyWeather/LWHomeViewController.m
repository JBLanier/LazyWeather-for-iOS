//
//  LWHomeViewController.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//


#import "LWHomeViewController.h"
#import "LWDailyForecast.h"
#import "LWWeatherStore.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    [self updateWeatherInfo];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:1];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:2];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:3];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:4];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:5];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:6];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:10];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:15];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:20];
    [self performSelector:@selector(updateWeatherInfo) withObject:self afterDelay:25];
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
    
    [self updateWeatherInfo];
}

- (void)updateWeatherInfo
{
    LWDailyForecast *todayForecast = [[LWWeatherStore sharedStore] forecastForDay:[NSDate date]];
    LWDailyForecast *tomorrowForecast = [[LWWeatherStore sharedStore] forecastForDay:[NSDate dateWithTimeIntervalSinceNow:86400]];
    NSNumber *low;
    NSNumber *high;
    
    if (todayForecast) {
        
        self.todayViewSummary.text = todayForecast.summary;
        self.todayViewRainChance.text = [NSString stringWithFormat:@"Chance of Rain: %d%%",(int)(todayForecast.precipitationProbability.floatValue *100)];
        high = todayForecast.highTemperature;
        self.todayViewHigh.text = [NSString stringWithFormat:@"Hi: %d", high.intValue];
        low = todayForecast.lowTemperature;
        self.todayViewLow.text = [NSString stringWithFormat:@"Lo: %d", low.intValue];
    }
    
    if (tomorrowForecast) {
    
        self.tomorrowViewSummary.text = tomorrowForecast.summary;
        self.tomorrowViewRainChance.text = [NSString stringWithFormat:@"Chance of Rain: %d%%",(int)(tomorrowForecast.precipitationProbability.floatValue * 100)];
        high = tomorrowForecast.highTemperature;
        self.tomorrowViewHigh.text = [NSString stringWithFormat:@"Hi: %d", high.intValue];
        low = tomorrowForecast.lowTemperature;
        self.tomorrowViewLow.text = [NSString stringWithFormat:@"Lo: %d", low.intValue];
    }
        
    [self updateViewConstraints];
    [self.view setNeedsDisplay];
    
}

- (IBAction)badgeButtonPressed:(id)sender
{
    [self updateWeatherInfo];
}

- (NSString *)description
{
    return @"LWHomeViewController";
}

@end
