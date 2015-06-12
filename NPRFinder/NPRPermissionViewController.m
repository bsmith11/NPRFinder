//
//  NPRPermissionViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRPermissionViewController.h"

static NSString * const kRequestLabelText = @"Can we use your location to find NPR stations near you?";

@interface NPRPermissionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *requestContainerView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;

@end

@implementation NPRPermissionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleLabel];
    [self setupRequestContainerView];
    [self setupRequestLabel];
    [self setupButtonContainerView];
    [self setupAcceptButton];
    [self setupDenyButton];
}

#pragma mark - Setup

- (void)setupTitleLabel {
//    [self.titleLabel npr_setupWithStyle:NPRLabelStyleSplash];
//    [self.titleLabel setText:kSplashTitleLabelText];
}

- (void)setupRequestContainerView {
//    [self.requestContainerView setBackgroundColor:[UIColor clearColor]];
}

- (void)setupRequestLabel {
//    [self.requestLabel npr_setupWithStyle:NPRLabelStyleError];
//    [self.requestLabel setText:kRequestLabelText];
}

- (void)setupButtonContainerView {
    [self.buttonContainerView setBackgroundColor:[UIColor clearColor]];
}

- (void)setupAcceptButton {
//    [self.acceptButton npr_setupWithStyle:NPRButtonStyleAcceptButton
//                                   target:self
//                                   action:@selector(acceptButtonPressed)];
}

- (void)setupDenyButton {
//    [self.denyButton npr_setupWithStyle:NPRButtonStyleDenyButton
//                                 target:self
//                                 action:@selector(denyButtonPressed)];
}

#pragma mark - Actions

- (void)acceptButtonPressed {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@YES forKey:kHasPassedFirstLaunch];
//    [userDefaults synchronize];
//    
//    [self pushToHome];
}

- (void)denyButtonPressed {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@YES forKey:kHasPassedFirstLaunch];
//    [userDefaults synchronize];
//    
//    [self pushToHome];
}

- (void)pushToHome {
//    HomeViewController *homeViewController = [[HomeViewController alloc] init];
//    
//    [self.navigationController pushViewController:homeViewController animated:NO];
}

@end
