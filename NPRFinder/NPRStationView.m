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
#import "NPRAnimationConstants.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

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

- (void)setupBackButton {
    self.backButton = [[NPRButton alloc] init];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backButton];

    [self.backButton npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.backButton npr_pinLeadingToSuperviewWithPadding:kNPRPadding];

    self.backButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Back Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:image forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor npr_foregroundColor];
    self.backButton.slopInset = UIEdgeInsetsMake(kNPRPadding, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupFrequencyLabel {
    self.frequencyLabel = [[UILabel alloc] init];
    self.frequencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.frequencyLabel];

    [self.frequencyLabel npr_centerHorizontallyInSuperview];
    [self.frequencyLabel npr_pinTopToView:self.backButton padding:kNPRPadding];

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
    self.overflowButton = [[NPRButton alloc] init];
    self.overflowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.overflowButton];

    [self.overflowButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
    [self.overflowButton npr_centerVerticallyWithView:self.marketLocationLabel];

    self.overflowButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Overflow Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.overflowButton setImage:image forState:UIControlStateNormal];
    self.overflowButton.tintColor = [UIColor npr_foregroundColor];
    self.overflowButton.slopInset = UIEdgeInsetsMake(kNPRPadding, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupCloseButton {
    self.closeButton = [[NPRButton alloc] init];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.closeButton];

    [self.closeButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.closeButton npr_centerVerticallyWithView:self.overflowButton];

    self.closeButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Close Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.closeButton setImage:image forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor npr_foregroundColor];
    self.closeButton.slopInset = UIEdgeInsetsMake(kNPRPadding / 2.0f, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupTwitterButton {
    self.twitterButton = [[NPRButton alloc] init];
    self.twitterButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.twitterButton];

    [self.twitterButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.twitterButton npr_pinBottomToView:self.overflowButton padding:kNPRPadding];

    self.twitterButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Twitter Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.twitterButton setImage:image forState:UIControlStateNormal];
    self.twitterButton.tintColor = [UIColor npr_foregroundColor];
    self.twitterButton.slopInset = UIEdgeInsetsMake(kNPRPadding / 2.0f, kNPRPadding, kNPRPadding / 2.0f, kNPRPadding);
}

- (void)setupFacebookButton {
    self.facebookButton = [[NPRButton alloc] init];
    self.facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.facebookButton];

    [self.facebookButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.facebookButton npr_pinBottomToView:self.twitterButton padding:kNPRPadding];

    self.facebookButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Facebook Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.facebookButton setImage:image forState:UIControlStateNormal];
    self.facebookButton.tintColor = [UIColor npr_foregroundColor];
    self.facebookButton.slopInset = UIEdgeInsetsMake(kNPRPadding / 2.0f, kNPRPadding, kNPRPadding / 2.0f, kNPRPadding);
}

- (void)setupWebButton {
    self.webButton = [[NPRButton alloc] init];
    self.webButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.webButton];

    [self.webButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.webButton npr_pinBottomToView:self.facebookButton padding:kNPRPadding];

    self.webButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Web Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.webButton setImage:image forState:UIControlStateNormal];
    self.webButton.tintColor = [UIColor npr_foregroundColor];
    self.webButton.slopInset = UIEdgeInsetsMake(kNPRPadding / 2.0f, kNPRPadding, kNPRPadding / 2.0f, kNPRPadding);
}

- (void)setupEmailButton {
    self.emailButton = [[NPRButton alloc] init];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.emailButton];

    [self.emailButton npr_centerHorizontallyWithView:self.overflowButton];
    [self.emailButton npr_pinBottomToView:self.webButton padding:kNPRPadding];

    self.emailButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Email Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailButton setImage:image forState:UIControlStateNormal];
    self.emailButton.tintColor = [UIColor npr_foregroundColor];
    self.emailButton.slopInset = UIEdgeInsetsMake(kNPRPadding / 2.0f, kNPRPadding, kNPRPadding / 2.0f, kNPRPadding);
}

#pragma mark - Animations

- (void)showViews {
    [self.animatingViews pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
        view.pop_spring.alpha = 1.0f;
    } completion:nil];
}

- (void)hideViews {
    [self.animatingViews pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.pop_spring.alpha = 0.0f;
    } completion:nil];
}

- (void)showOverflowButtons {
    self.overflowButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.overflowButton.pop_spring.alpha = 0.0f;

    [self.overflowButtons addObject:self.closeButton];

    [self.overflowButtons pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
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
    [reverseOverflowButtons pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
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
