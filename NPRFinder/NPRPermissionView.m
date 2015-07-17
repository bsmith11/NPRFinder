//
//  NPRPermissionView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRPermissionView.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAutoLayout.h"
#import "UIScreen+NPRUtil.h"
#import "NPRAnimationConstants.h"
#import "UIView+NPRAnimation.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

static NSString * const kNPRPermissionRequestLabelText = @"Discover uses your location to find NPR stations near you";
static NSString * const kNPRPermissionAcceptButtonTitle = @"Enable Location Services";
static NSString * const kNPRPermissionDenyButtonTitle = @"Not now";

@interface NPRPermissionView ()

@property (strong, nonatomic) NSArray *animatingViews;

@end

@implementation NPRPermissionView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];

    [self setupLocationServicesImageView];
    [self setupRequestLabel];
    [self setupAcceptButton];
    [self setupDenyButton];

    self.animatingViews = @[self.locationServicesImageView, self.requestLabel, self.acceptButton, self.denyButton];

    for (UIView *view in self.animatingViews) {
        [view npr_shrinkAnimated:NO];
    }
}

#pragma mark - Setup

- (void)setupLocationServicesImageView {
    UIImage *image = [[UIImage imageNamed:@"Location Services Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.locationServicesImageView = [[UIImageView alloc] initWithImage:image];
    self.locationServicesImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.locationServicesImageView];

    [self.locationServicesImageView npr_centerHorizontallyInSuperview];
    [self.locationServicesImageView npr_pinTopToSuperviewWithPadding:2.0f * kNPRPadding];

    self.locationServicesImageView.backgroundColor = [UIColor clearColor];
    self.locationServicesImageView.contentMode = UIViewContentModeCenter;
    self.locationServicesImageView.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupRequestLabel {
    self.requestLabel = [[UILabel alloc] init];
    self.requestLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.requestLabel];

    [self.requestLabel npr_fillSuperviewHorizontallyWithPadding:kNPRPadding];
    [self.requestLabel npr_pinTopToView:self.locationServicesImageView padding:kNPRPadding];

    self.requestLabel.backgroundColor = [UIColor clearColor];
    self.requestLabel.textColor = [UIColor npr_foregroundColor];
    self.requestLabel.font = [UIFont npr_permissionRequestFont];
    self.requestLabel.numberOfLines = 0;
    self.requestLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.requestLabel.textAlignment = NSTextAlignmentCenter;
    self.requestLabel.text = kNPRPermissionRequestLabelText;
}

- (void)setupAcceptButton {
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.acceptButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.acceptButton];

    [self.acceptButton npr_centerHorizontallyInSuperview];
    [self.acceptButton npr_pinTopToView:self.requestLabel padding:2.0f * kNPRPadding];

    self.acceptButton.backgroundColor = [UIColor clearColor];
    [self.acceptButton setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
    self.acceptButton.titleLabel.font = [UIFont npr_permissionAcceptFont];
    self.acceptButton.titleLabel.numberOfLines = 0;
    self.acceptButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.acceptButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.acceptButton setTitle:kNPRPermissionAcceptButtonTitle forState:UIControlStateNormal];
}

- (void)setupDenyButton {
    self.denyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.denyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.denyButton];

    [self.denyButton npr_centerHorizontallyInSuperview];
    [self.denyButton npr_pinBottomToSuperviewWithPadding:kNPRPadding];

    self.denyButton.backgroundColor = [UIColor clearColor];
    [self.denyButton setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
    self.denyButton.titleLabel.font = [UIFont npr_permissionDenyFont];
    self.denyButton.titleLabel.numberOfLines = 0;
    self.denyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.denyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.denyButton setTitle:kNPRPermissionDenyButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Animations

- (void)showViews {
    [self.animatingViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view npr_growAnimated:YES delay:idx * kNPRAnimationInterval];
    }];
}

- (void)hideViews {
    [self.animatingViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view npr_shrinkAnimated:YES delay:idx * kNPRAnimationInterval];
    }];
}

@end
