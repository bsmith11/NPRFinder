//
//  SplashViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "SplashViewController.h"
#import "UIImage+NPRFinder.h"
#import "UILabel+NPRFinder.h"
#import "UIButton+NPRFinder.h"
#import "UIView+NPRFinder.h"
#import "HomeViewController.h"

static NSString * const kSplashTitleLabelText = @"Discover";
static NSString * const kHasPassedFirstLaunch = @"npr_has_passed_first_launch";
static NSString * const kRequestLabelText = @"Can we use your location to find NPR stations near you?";

static const CGFloat kSplashTitleLabelAnimationDuration = 0.5;
static const CGFloat kLocationServicesAnimationDuration = 0.5;

@interface SplashViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *requestContainerView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;

@end

@implementation SplashViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setupTitleLabel];
    [self setupRequestContainerView];
    [self setupRequestLabel];
    [self setupButtonContainerView];
    [self setupAcceptButton];
    [self setupDenyButton];
    
    [self hideLocationServicesRequestAnimated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hideTitleLabelAnimated:YES completion:^(BOOL finished) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSNumber *hasPassedFirstLaunch = [userDefaults objectForKey:kHasPassedFirstLaunch];
        if (!hasPassedFirstLaunch) {
            [self showLocationServicesRequestAnimated:YES completion:nil];
        }
        else {
            [self pushToHome];
        }
    }];
}

#pragma mark - Setup

- (void)setupTitleLabel {
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleSplash];
    [self.titleLabel setText:kSplashTitleLabelText];
}

- (void)setupRequestContainerView {
    [self.requestContainerView setBackgroundColor:[UIColor clearColor]];
}

- (void)setupRequestLabel {
    [self.requestLabel npr_setupWithStyle:NPRLabelStyleError];
    [self.requestLabel setText:kRequestLabelText];
}

- (void)setupButtonContainerView {
    [self.buttonContainerView setBackgroundColor:[UIColor clearColor]];
}

- (void)setupAcceptButton {
    [self.acceptButton npr_setupWithStyle:NPRButtonStyleAcceptButton
                                   target:self
                                   action:@selector(acceptButtonPressed)];
}

- (void)setupDenyButton {
    [self.denyButton npr_setupWithStyle:NPRButtonStyleDenyButton
                                 target:self
                                 action:@selector(denyButtonPressed)];
    
}

#pragma mark - Actions

- (void)acceptButtonPressed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@YES forKey:kHasPassedFirstLaunch];
    [userDefaults synchronize];
    
    [self pushToHome];
}

- (void)denyButtonPressed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@YES forKey:kHasPassedFirstLaunch];
    [userDefaults synchronize];
    
    [self pushToHome];
}

- (void)pushToHome {
    HomeViewController *homeViewController = [HomeViewController new];
    
    [self.navigationController pushViewController:homeViewController animated:NO];
}

#pragma mark - Animations

- (void)showTitleLabelAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.titleLabel npr_setAlpha:1.0
                         duration:kSplashTitleLabelAnimationDuration
                         animated:animated
                       completion:completion];
}

- (void)hideTitleLabelAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.titleLabel npr_setAlpha:0.0
                         duration:kSplashTitleLabelAnimationDuration
                         animated:animated
                       completion:completion];
}

- (void)showLocationServicesRequestAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.requestContainerView npr_setAlpha:1.0
                                   duration:kLocationServicesAnimationDuration
                                   animated:animated
                                 completion:completion];
}

- (void)hideLocationServicesRequestAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.requestContainerView npr_setAlpha:0.0
                                   duration:kLocationServicesAnimationDuration
                                   animated:animated
                                 completion:completion];
}

@end
