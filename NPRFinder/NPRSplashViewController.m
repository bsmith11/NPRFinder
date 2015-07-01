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

    CGFloat delay = 1.0f;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didFinishAnimatingSplashViewController:)]) {
            [self.delegate didFinishAnimatingSplashViewController:self];
        }
    });
}

#pragma mark - Setup

- (void)setupSplashView {
    self.splashView = [[NPRSplashView alloc] init];
    self.splashView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.splashView];

    [self.splashView npr_fillSuperview];
}

@end
