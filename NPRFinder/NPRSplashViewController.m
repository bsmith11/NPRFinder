//
//  NPRSplashViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSplashViewController.h"

#import "NPRSplashView.h"
#import "UIView+NPRAutoLayout.h"

@interface NPRSplashViewController ()

@property (strong, nonatomic) NPRSplashView *splashView;

@end

@implementation NPRSplashViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSplashView];
}

#pragma mark - Setup

- (void)setupSplashView {
    self.splashView = [[NPRSplashView alloc] init];
    self.splashView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.splashView];

    [self.splashView npr_fillSuperview];
}

@end
