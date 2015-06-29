//
//  NPRStationView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationView.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIView+NPRAutoLayout.h"
#import "UIScreen+NPRUtil.h"
#import "NPRStyleConstants.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

static const CGFloat kNPRAnimationScaleValue = 0.1f;

@interface NPRStationView ()

@property (strong, nonatomic) NSMutableArray *overflowButtons;

@end

@implementation NPRStationView

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
    self.backgroundColor = [UIColor npr_redColor];

    [self setupTopBarContainerView];
    [self setupBackButton];
    [self setupFrequencyLabel];
    [self setupCallLabel];
    [self setupAudioActionButton];
    [self setupAudioActivityIndicatorView];
    [self setupMarketLocationLabel];
    [self setupOverflowButton];
    [self setupCloseButton];
    [self setupTwitterButton];
    [self setupFacebookButton];
    [self setupWebButton];
    [self setupEmailButton];

    self.animatingViews = [NSMutableArray arrayWithArray:@[self.backButton, self.frequencyLabel, self.callLabel, self.audioActionButton, self.overflowButton, self.marketLocationLabel]];

    self.overflowButtons = [NSMutableArray arrayWithArray:@[self.twitterButton, self.facebookButton, self.webButton, self.emailButton]];

    for (UIView *view in self.animatingViews) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }

    for (UIView *view in self.overflowButtons) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }

    self.closeButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.closeButton.alpha = 0.0f;
}

#pragma mark - Setup

- (void)setupTopBarContainerView {
    self.topBarContainerView = [[UIView alloc] init];
    self.topBarContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.topBarContainerView];

    [self.topBarContainerView npr_fillSuperviewHorizontally];
    [self.topBarContainerView npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.topBarContainerView npr_pinHeight:[UIScreen npr_navigationBarHeight]];

    self.topBarContainerView.backgroundColor = [UIColor clearColor];
}

- (void)setupBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topBarContainerView addSubview:self.backButton];

    [self.backButton npr_centerVerticallyInSuperview];
    [self.backButton npr_pinLeadingToSuperviewWithPadding:kNPRPadding];

    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setImage:[UIImage imageNamed:@"Back Icon"] forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupFrequencyLabel {
    self.frequencyLabel = [[UILabel alloc] init];
    self.frequencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.frequencyLabel];

    [self.frequencyLabel npr_centerHorizontallyInSuperview];
    [self.frequencyLabel npr_pinTopToView:self.topBarContainerView];

    self.frequencyLabel.backgroundColor = [UIColor clearColor];
    self.frequencyLabel.textColor = [UIColor npr_foregroundColor];
    self.frequencyLabel.font = [UIFont npr_stationFrequencyFont];
    self.frequencyLabel.numberOfLines = 1;
    self.frequencyLabel.lineBreakMode = NSLineBreakByClipping;
    self.frequencyLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupCallLabel {
    self.callLabel = [[UILabel alloc] init];
    self.callLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.callLabel];

    [self.callLabel npr_centerHorizontallyInSuperview];
    [self.callLabel npr_pinTopToView:self.frequencyLabel padding:kNPRPadding / 2.0f];

    self.callLabel.backgroundColor = [UIColor clearColor];
    self.callLabel.textColor = [UIColor npr_foregroundColor];
    self.callLabel.font = [UIFont npr_stationCallFont];
    self.callLabel.numberOfLines = 1;
    self.callLabel.lineBreakMode = NSLineBreakByClipping;
    self.callLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupAudioActionButton {
    self.audioActionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.audioActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.audioActionButton];

    [self.audioActionButton npr_centerHorizontallyInSuperview];
    [self.audioActionButton npr_pinTopToView:self.callLabel padding:2.0f * kNPRPadding];

    self.audioActionButton.backgroundColor = [UIColor clearColor];
    self.audioActionButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupAudioActivityIndicatorView {
    self.audioActivityIndicatorView = [[NPRActivityIndicatorView alloc] init];
    self.audioActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.audioActivityIndicatorView];

    [self.audioActivityIndicatorView npr_centerHorizontallyWithView:self.audioActionButton];
    [self.audioActivityIndicatorView npr_centerVerticallyWithView:self.audioActionButton];

    self.audioActivityIndicatorView.color = [UIColor npr_foregroundColor];
}

- (void)setupMarketLocationLabel {
    self.marketLocationLabel = [[UILabel alloc] init];
    self.marketLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.marketLocationLabel];

    [self.marketLocationLabel npr_pinLeadingToSuperviewWithPadding:kNPRPadding];
    [self.marketLocationLabel npr_pinBottomToSuperviewWithPadding:kNPRPadding];

    self.marketLocationLabel.backgroundColor = [UIColor clearColor];
    self.marketLocationLabel.textColor = [UIColor npr_foregroundColor];
    self.marketLocationLabel.font = [UIFont npr_stationMarketLocationFont];
    self.marketLocationLabel.numberOfLines = 1;
    self.marketLocationLabel.lineBreakMode = NSLineBreakByClipping;
    self.marketLocationLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setupOverflowButton {
    self.overflowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.overflowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.overflowButton];

    [self.overflowButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
    [self.overflowButton npr_centerVerticallyWithView:self.marketLocationLabel];

    self.overflowButton.backgroundColor = [UIColor clearColor];
    [self.overflowButton setImage:[UIImage imageNamed:@"Overflow Icon"] forState:UIControlStateNormal];
    self.overflowButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.closeButton];

    [self.closeButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.closeButton npr_centerVerticallyWithView:self.overflowButton];

    self.closeButton.backgroundColor = [UIColor clearColor];
    [self.closeButton setImage:[UIImage imageNamed:@"Close Icon"] forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupTwitterButton {
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.twitterButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.twitterButton];

    [self.twitterButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.twitterButton npr_pinBottomToView:self.overflowButton padding:kNPRPadding];

    self.twitterButton.backgroundColor = [UIColor clearColor];
    [self.twitterButton setImage:[UIImage imageNamed:@"Twitter Icon"] forState:UIControlStateNormal];
    self.twitterButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupFacebookButton {
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.facebookButton];

    [self.facebookButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.facebookButton npr_pinBottomToView:self.twitterButton padding:kNPRPadding];

    self.facebookButton.backgroundColor = [UIColor clearColor];
    [self.facebookButton setImage:[UIImage imageNamed:@"Facebook Icon"] forState:UIControlStateNormal];
    self.facebookButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupWebButton {
    self.webButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.webButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.webButton];

    [self.webButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.webButton npr_pinBottomToView:self.facebookButton padding:kNPRPadding];

    self.webButton.backgroundColor = [UIColor clearColor];
    [self.webButton setImage:[UIImage imageNamed:@"Web Icon"] forState:UIControlStateNormal];
    self.webButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupEmailButton {
    self.emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.emailButton];

    [self.emailButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.emailButton npr_pinBottomToView:self.webButton padding:kNPRPadding];

    self.emailButton.backgroundColor = [UIColor clearColor];
    [self.emailButton setImage:[UIImage imageNamed:@"Email Icon"] forState:UIControlStateNormal];
    self.emailButton.tintColor = [UIColor npr_foregroundColor];
}

#pragma mark - Animations

- (void)showViews {
    [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
        view.pop_spring.alpha = 1.0f;
    } completion:nil];
}

- (void)hideViews {
    [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.pop_spring.alpha = 0.0f;
    } completion:nil];
}

- (void)showOverflowButtons {
    self.overflowButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.overflowButton.pop_spring.alpha = 0.0f;

    [self.overflowButtons addObject:self.closeButton];

    [self.overflowButtons pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
        view.pop_spring.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.overflowButtons removeObject:self.closeButton];
    }];
}

- (void)hideOverflowButtons {
    self.closeButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.closeButton.pop_spring.alpha = 0.0f;

    NSMutableArray *reverseOverflowButtons = [[[self.overflowButtons reverseObjectEnumerator] allObjects] mutableCopy];
    [reverseOverflowButtons addObject:self.overflowButton];
    [reverseOverflowButtons pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        if (view == self.overflowButton) {
            self.overflowButton.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
            self.overflowButton.pop_spring.alpha = 1.0f;
        }
        else {
            view.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
            view.pop_spring.alpha = 0.0f;
        }
    } completion:nil];
}

@end
