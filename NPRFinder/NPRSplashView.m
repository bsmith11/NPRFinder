//
//  NPRSplashView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSplashView.h"

#import "UIColor+NPRStyle.h"
#import "UIView+NPRAutoLayout.h"
#import "UIScreen+NPRUtil.h"
#import "UIFont+NPRStyle.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAnimation.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

@interface NPRSplashView ()

@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) NSLayoutConstraint *leftViewWidth;
@property (strong, nonatomic) NSLayoutConstraint *leftViewHeight;
@property (strong, nonatomic) UIView *middleView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) NSLayoutConstraint *rightViewWidth;
@property (strong, nonatomic) NSLayoutConstraint *rightViewHeight;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *middleLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *discoverLabel;

@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat verticalCenterOffset;

@end

@implementation NPRSplashView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor darkGrayColor];

    self.viewWidth = [UIScreen npr_screenWidth] / 3.0f;
    self.verticalCenterOffset = [UIScreen npr_screenHeight] / 4.0f;

    [self setupMiddleView];
    [self setupLeftView];
    [self setupRightView];

    [self setupLeftLabel];
    [self setupMiddleLabel];
    [self setupRightLabel];

    [self setupDiscoverLabel];
}

#pragma mark - Setup

- (void)setupMiddleView {
    self.middleView = [[UIView alloc] init];
    self.middleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.middleView];

    [self.middleView npr_pinSize:CGSizeMake(self.viewWidth, self.viewWidth)];
    [self.middleView npr_centerVerticallyInSuperviewWithOffset:-self.verticalCenterOffset];
    [self.middleView npr_centerHorizontallyInSuperview];

    self.middleView.backgroundColor = [UIColor npr_blackColor];
}

- (void)setupLeftView {
    self.leftView = [[UIView alloc] init];
    self.leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftView];

    self.leftViewWidth = [self.leftView npr_pinWidth:self.viewWidth];
    self.leftViewHeight = [self.leftView npr_pinHeight:self.viewWidth];
    [self.leftView npr_centerVerticallyWithView:self.middleView];
    [self.leftView npr_pinLeadingToSuperview];

    self.leftView.backgroundColor = [UIColor npr_redColor];
}

- (void)setupRightView {
    self.rightView = [[UIView alloc] init];
    self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rightView];

    self.rightViewWidth = [self.rightView npr_pinWidth:self.viewWidth];
    self.rightViewHeight = [self.rightView npr_pinHeight:self.viewWidth];
    [self.rightView npr_centerVerticallyWithView:self.middleView];
    [self.rightView npr_pinTrailingToSuperview];

    self.rightView.backgroundColor = [UIColor npr_blueColor];
}

- (void)setupLeftLabel {
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftView addSubview:self.leftLabel];

    [self.leftLabel npr_pinSize:CGSizeMake(self.viewWidth, self.viewWidth)];
    [self.leftLabel npr_centerVerticallyInSuperview];
    [self.leftLabel npr_pinLeadingToSuperview];

    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.text = @"n";
    self.leftLabel.font = [UIFont npr_splashFont];
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupMiddleLabel {
    self.middleLabel = [[UILabel alloc] init];
    self.middleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.middleView addSubview:self.middleLabel];

    [self.middleLabel npr_pinSize:CGSizeMake(self.viewWidth, self.viewWidth)];
    [self.middleLabel npr_centerHorizontallyInSuperview];
    [self.middleLabel npr_centerVerticallyInSuperview];

    self.middleLabel.backgroundColor = [UIColor clearColor];
    self.middleLabel.text = @"p";
    self.middleLabel.font = [UIFont npr_splashFont];
    self.middleLabel.textColor = [UIColor whiteColor];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupRightLabel {
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightView addSubview:self.rightLabel];

    [self.rightLabel npr_pinSize:CGSizeMake(self.viewWidth, self.viewWidth)];
    [self.rightLabel npr_centerVerticallyInSuperview];
    [self.rightLabel npr_pinTrailingToSuperview];

    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.text = @"r";
    self.rightLabel.font = [UIFont npr_splashFont];
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupDiscoverLabel {
    self.discoverLabel = [[UILabel alloc] init];
    self.discoverLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.discoverLabel];

    [self.discoverLabel npr_centerHorizontallyInSuperview];
    [self.discoverLabel npr_pinTopToView:self.middleView padding:kNPRPadding];

    self.discoverLabel.backgroundColor = [UIColor clearColor];
    self.discoverLabel.text = @"DISCOVER";
    self.discoverLabel.font = [UIFont npr_splashDiscoverFont];
    self.discoverLabel.textColor = [UIColor whiteColor];
    self.discoverLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Animations

- (void)expandLeftViewWithCompletion:(void (^)(BOOL))completion {
    [self bringSubviewToFront:self.leftView];

    [NSObject pop_animate:^{
        [self.leftLabel npr_shrinkAnimated:YES];

        self.leftViewWidth.pop_springBounciness = 0.0f;
        self.leftViewWidth.pop_spring.constant = [UIScreen npr_screenWidth];

        self.leftViewHeight.pop_springBounciness = 0.0f;
        self.leftViewHeight.pop_spring.constant = [UIScreen npr_screenHeight] + (self.verticalCenterOffset * 2.0f);
    } completion:completion];
}

- (void)expandRightViewWithCompletion:(void (^)(BOOL))completion {
    [self bringSubviewToFront:self.rightView];

    [NSObject pop_animate:^{
        [self.rightLabel npr_shrinkAnimated:YES];

        self.rightViewWidth.pop_springBounciness = 0.0f;
        self.rightViewWidth.pop_spring.constant = [UIScreen npr_screenWidth];

        self.rightViewHeight.pop_springBounciness = 0.0f;
        self.rightViewHeight.pop_spring.constant = [UIScreen npr_screenHeight] + (self.verticalCenterOffset * 2.0f);
    } completion:completion];
}

@end
