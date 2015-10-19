//
//  LWHomeViewController.m
//  LazyWeather
//
//  Created by John Lanier and Arthur Pan on 10/10/15.
//  Copyright © 2015 LazyWeather Team. All rights reserved.
//

#import "LWHomeViewController.h"
#import "LWWeatherUpdateManager.h"
#import "LWWeatherStore.h"
#import "LWDailyForecast.h"

@import CoreLocation;

@interface LWHomeViewController ()

@property (nonatomic) BOOL isWeatherDataOnScreen;

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

@property (weak, nonatomic) IBOutlet UILabel *locationGeoCode;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidesWhenStopped = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**********************************************************************************************/
#pragma mark - Navigation
/**********************************************************************************************/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[LWWeatherUpdateManager sharedManager] setSubscriberToWeatherUpdates:self];
    [self updateWeatherInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[LWWeatherUpdateManager sharedManager] removeSubscriberToWeatherUpdates];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self updateWeatherInfo];
}

/**********************************************************************************************/
#pragma mark - updateWeatherInfo
/**********************************************************************************************/

- (void)updateWeatherInfo {
    LWDailyForecast *todayForecast = [[LWWeatherStore sharedStore] forecastForDay:[NSDate date]];
    LWDailyForecast *tomorrowForecast = [[LWWeatherStore sharedStore] forecastForDay:[NSDate dateWithTimeIntervalSinceNow:86400]];
    NSInteger low;
    NSInteger high;
    NSInteger percent;
    
    if (todayForecast) {
        
        self.todayViewSummary.text = todayForecast.summary;
        percent = todayForecast.precipitationProbability;
        if (percent != -100) {
            
            self.isWeatherDataOnScreen = YES;
            [self.activityIndicator stopAnimating];
            
            self.todayViewDay.hidden = NO;
            self.badgeButton.hidden = NO;
            self.todayViewRainChance.text = [NSString stringWithFormat:@"Chance of Rain: %ld%%",(long)percent];
            high = todayForecast.highTemperature;
            self.todayViewHigh.text = [NSString stringWithFormat:@"Hi: %ld", (long)high];
            low = todayForecast.lowTemperature;
            self.todayViewLow.text = [NSString stringWithFormat:@"Lo: %ld", (long)low];
        } else {
            self.isWeatherDataOnScreen = NO;
            self.todayViewDay.hidden = YES;
            self.badgeButton.hidden = YES;
        }
    }
    
    if (tomorrowForecast) {
    
        self.tomorrowViewSummary.text = tomorrowForecast.summary;
        percent = tomorrowForecast.precipitationProbability;
        if (percent != -100) {
            self.tomorrowViewDay.hidden = NO;
            self.badgeButton.hidden = NO;
            self.tomorrowViewRainChance.text = [NSString stringWithFormat:@"Chance of Rain: %ld%%",(long)percent];
            high = tomorrowForecast.highTemperature;
            self.tomorrowViewHigh.text = [NSString stringWithFormat:@"Hi: %ld", (long)high];
            low = tomorrowForecast.lowTemperature;
            self.tomorrowViewLow.text = [NSString stringWithFormat:@"Lo: %ld", (long)low];
        } else {
            self.tomorrowViewDay.hidden = YES;
            self.badgeButton.hidden = YES;
        }
    }
    
    if ([[LWWeatherStore sharedStore] localityOfForecasts])
        self.locationGeoCode.text = [NSString stringWithFormat:@"%@", [[LWWeatherStore sharedStore] localityOfForecasts]];
                                 
    [self updateViewConstraints];
    [self.view setNeedsDisplay];
    
}

/**********************************************************************************************/
#pragma mark - Activity Indicator
/**********************************************************************************************/

- (void)weatherUpdateFailed {
    [self.activityIndicator stopAnimating];
}

- (void)weatherUpdateStarted {
    if (!self.isWeatherDataOnScreen && [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self.activityIndicator startAnimating];
    }
}

/**********************************************************************************************/
#pragma mark - Misc
/**********************************************************************************************/

- (IBAction)badgeButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://forecast.io/"]];
}

- (NSString *)description {
    return @"LWHomeViewController";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
