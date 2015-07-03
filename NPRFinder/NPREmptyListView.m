//
//  NPREmptyListView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/16/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPREmptyListView.h"

#import "UIFont+NPRStyle.h"
#import "UIColor+NPRStyle.h"
#import "UIScreen+NPRUtil.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAutoLayout.h"
#import "NSError+NPRUtil.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

@interface NPREmptyListView ()

@property (strong, nonatomic) UILabel *emptyListLabel;
@property (strong, nonatomic) UIButton *actionButton;

@end

@implementation NPREmptyListView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        [self setupEmptyListLabel];
        [self setupActionButton];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupEmptyListLabel {
    self.emptyListLabel = [[UILabel alloc] init];
    self.emptyListLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.emptyListLabel];

    [self.emptyListLabel npr_fillSuperviewHorizontally];
    [self.emptyListLabel npr_pinTopToSuperview];

    self.emptyListLabel.backgroundColor = [UIColor clearColor];
    self.emptyListLabel.textColor = [UIColor npr_foregroundColor];
    self.emptyListLabel.font = [UIFont npr_homeEmptyListFont];
    self.emptyListLabel.numberOfLines = 0;
    self.emptyListLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyListLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupActionButton {
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionButton];

    [self.actionButton npr_centerHorizontallyInSuperview];
    [self.actionButton npr_pinBottomToSuperview];
    [self.actionButton npr_pinTopToView:self.emptyListLabel padding:kNPRPadding];

    self.actionButton.backgroundColor = [UIColor clearColor];
    [self.actionButton setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont npr_homeEmptyListFont];
    self.actionButton.titleLabel.numberOfLines = 0;
    self.actionButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.actionButton addTarget:self action:@selector(actionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWithError:(NSError *)error {
    if (error && error.userInfo) {
        NSString *text = error.userInfo[kNPRErrorTextKey];
        NSString *action = error.userInfo[kNPRErrorActionKey];

        self.emptyListLabel.text = text;
        [self.actionButton setTitle:action forState:UIControlStateNormal];
    }
    else {
        self.emptyListLabel.text = @"";
        [self.actionButton setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (void)actionButtonTapped {
    if ([self.delegate respondsToSelector:@selector(didSelectActionInEmptyListView:)]) {
        [self.delegate didSelectActionInEmptyListView:self];
    }
}

@end
