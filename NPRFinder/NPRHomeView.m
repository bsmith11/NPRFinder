//
//  NPRHomeView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeView.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIScreen+NPRUtil.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAutoLayout.h"
#import "NPRCollectionViewLayout.h"
#import "NPRAnimationConstants.h"
#import "NPRStationCell.h"
#import "UIView+NPRAnimation.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

static NSString * const kNPRHomeEmptyListText = @"No stations found";
static NSString * const kNPRHomeEmptyListActionText = @"Try again?";

@interface NPRHomeView ()

@property (strong, nonatomic) NSLayoutConstraint *locationButtonTrailing;
@property (strong, nonatomic) NSLayoutConstraint *searchButtonTrailing;
@property (strong, nonatomic) NSArray *animatingConstraints;

@end

@implementation NPRHomeView

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

    [self setupHomeCollectionView];
    [self setupLocationButton];
    [self setupSearchButton];
    [self setupEmptyListView];
    [self setupActivityIndicatorView];

    [self.emptyListView npr_shrinkAnimated:NO];
    self.locationButtonTrailing.constant = -[self.locationButton imageForState:UIControlStateNormal].size.width;
    self.searchButtonTrailing.constant = -[self.searchButton imageForState:UIControlStateNormal].size.width;

    self.animatingConstraints = @[self.locationButtonTrailing, self.searchButtonTrailing];
}

#pragma mark - Setup

- (void)setupHomeCollectionView {
    NPRCollectionViewLayout *layout = [[NPRCollectionViewLayout alloc] init];
    self.homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.homeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.homeCollectionView];

    [self.homeCollectionView npr_fillSuperview];

    self.homeCollectionView.backgroundColor = [UIColor clearColor];
    self.homeCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.homeCollectionView.alwaysBounceVertical = YES;
    self.homeCollectionView.delaysContentTouches = NO;
    [self.homeCollectionView registerClass:[NPRStationCell class]
                forCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier]];
}

- (void)setupLocationButton {
    self.locationButton = [[NPRButton alloc] init];
    self.locationButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.locationButton];

    self.locationButtonTrailing = [self.locationButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding];

    self.locationButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Location Services Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationButton setImage:image forState:UIControlStateNormal];
    self.locationButton.tintColor = [UIColor npr_foregroundColor];
    self.locationButton.slopInset = UIEdgeInsetsMake(kNPRPadding, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupSearchButton {
    self.searchButton = [[NPRButton alloc] init];
    self.searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchButton];

    self.searchButtonTrailing = [self.searchButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
    [self.searchButton npr_pinTopToView:self.locationButton padding:kNPRPadding];
    [self.searchButton npr_pinBottomToSuperviewWithPadding:kNPRPadding];

    self.searchButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Search Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchButton setImage:image forState:UIControlStateNormal];
    self.searchButton.tintColor = [UIColor npr_foregroundColor];
    self.searchButton.slopInset = UIEdgeInsetsMake(kNPRPadding, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupEmptyListView {
    self.emptyListView = [[NPREmptyListView alloc] init];
    [self addSubview:self.emptyListView];

    [self.emptyListView npr_fillSuperviewHorizontallyWithPadding:kNPRPadding];
    [self.emptyListView npr_centerVerticallyInSuperview];
}

- (void)setupActivityIndicatorView {
    self.activityIndicatorView = [[NPRActivityIndicatorView alloc] init];
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicatorView];

    [self.activityIndicatorView npr_centerHorizontallyInSuperview];
    [self.activityIndicatorView npr_centerVerticallyInSuperview];

    self.activityIndicatorView.color = [UIColor npr_foregroundColor];
}

#pragma mark - Animations

- (void)showSearchButtonAnimated:(BOOL)animated {
    [self showSearchButtonAnimated:animated delay:0.0f];
}

- (void)showSearchButtonAnimated:(BOOL)animated delay:(CGFloat)delay {
    if (animated) {
        self.searchButtonTrailing.pop_beginTime = CACurrentMediaTime() + delay;
        self.searchButtonTrailing.pop_spring.constant = kNPRPadding;
    }
    else {
        self.searchButtonTrailing.constant = kNPRPadding;
    }
}

- (void)hideSearchButtonAnimated:(BOOL)animated {
    [self hideSearchButtonAnimated:animated delay:0.0f];
}

- (void)hideSearchButtonAnimated:(BOOL)animated delay:(CGFloat)delay {
    CGFloat value = -[self.searchButton imageForState:UIControlStateNormal].size.width;

    if (animated) {
        self.searchButtonTrailing.pop_beginTime = CACurrentMediaTime() + delay;
        self.searchButtonTrailing.pop_spring.constant = value;
    }
    else {
        self.searchButtonTrailing.constant = value;
    }
}

- (void)showEmptyListViewAnimated:(BOOL)animated {
    [self showEmptyListViewAnimated:animated delay:0.0f];
}

- (void)showEmptyListViewAnimated:(BOOL)animated delay:(CGFloat)delay {
    [self.emptyListView npr_growAnimated:animated delay:delay];
}

- (void)hideEmptyListViewAnimated:(BOOL)animated {
    [self hideEmptyListViewAnimated:animated delay:0.0f];
}

- (void)hideEmptyListViewAnimated:(BOOL)animated delay:(CGFloat)delay {
    [self.emptyListView npr_shrinkAnimated:animated delay:delay];
}

- (void)showActivityIndicatorViewAnimated:(BOOL)animated {
    [self.activityIndicatorView npr_growAnimated:animated];
}

- (void)hideActivityIndicatorViewAnimated:(BOOL)animated {
    [self.activityIndicatorView npr_shrinkAnimated:animated];
}

- (void)showViews {
    [self showViewsWithDelay:0.0f];
}

- (void)showViewsWithDelay:(CGFloat)delay {
    [self.animatingConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.pop_beginTime = CACurrentMediaTime() + (idx * kNPRAnimationInterval) + delay;
        constraint.pop_spring.constant = kNPRPadding;
    }];
}

- (void)hideViews {
    [self hideViewsWithDelay:0.0f];
}

- (void)hideViewsWithDelay:(CGFloat)delay {
    CGFloat value = -[self.locationButton imageForState:UIControlStateNormal].size.width;

    [self.animatingConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.pop_beginTime = CACurrentMediaTime() + (idx * kNPRAnimationInterval) + delay;
        constraint.pop_spring.constant = value;
    }];
}

@end
