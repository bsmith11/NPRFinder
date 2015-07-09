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

#import <POP+MCAnimate/POP+MCAnimate.h>

static NSString * const kNPRHomeEmptyListText = @"No stations found";
static NSString * const kNPRHomeEmptyListActionText = @"Try again?";
static NSString * const kNPRBrandLabelText = @"npr";

static const CGFloat kNPRBrandLabelTextKerning = 5.0f;

@interface NPRHomeView ()

@property (strong, nonatomic) NSLayoutConstraint *brandLabelTrailing;
@property (strong, nonatomic) NSLayoutConstraint *searchButtonTrailing;

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
    self.backgroundColor = [UIColor npr_redColor];

    [self setupHomeCollectionView];
    [self setupBrandLabel];
    [self setupSearchButton];
    [self setupEmptyListView];
    [self setupActivityIndicatorView];

    [self hideEmptyListViewAnimated:NO];
    self.searchButtonTrailing.constant = -[self.searchButton imageForState:UIControlStateNormal].size.width;
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

- (void)setupBrandLabel {
    self.brandLabel = [[UILabel alloc] init];
    self.brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.brandLabel];

    [self.brandLabel npr_pinTopToSuperviewWithPadding:kNPRPadding];
    self.brandLabelTrailing = [self.brandLabel npr_pinTrailingToSuperviewWithPadding:kNPRPadding];

    self.brandLabel.backgroundColor = [UIColor clearColor];
    self.brandLabel.hidden = YES;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor npr_foregroundColor],
                                 NSFontAttributeName:[UIFont npr_stationCallFont],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(kNPRBrandLabelTextKerning)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:kNPRBrandLabelText attributes:attributes];

    self.brandLabel.attributedText = attributedString;
}

- (void)setupSearchButton {
    self.searchButton = [[NPRButton alloc] init];
    self.searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchButton];

    self.searchButtonTrailing = [self.searchButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
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

- (void)showBrandLabelWithDelay:(CGFloat)delay {
    self.brandLabelTrailing.pop_beginTime = CACurrentMediaTime() + delay;
    self.brandLabelTrailing.pop_spring.constant = kNPRPadding;
}

- (void)hideBrandLabel {
    self.brandLabelTrailing.pop_spring.constant = -CGRectGetWidth(self.brandLabel.frame);
}

- (void)showSearchButtonWithDelay:(CGFloat)delay {
    self.searchButtonTrailing.pop_beginTime = CACurrentMediaTime() + delay;
    self.searchButtonTrailing.pop_spring.constant = kNPRPadding;
}

- (void)hideSearchButton {
    self.searchButtonTrailing.pop_spring.constant = -CGRectGetWidth(self.searchButton.frame);
}

- (void)showEmptyListViewWithDelay:(CGFloat)delay {
    self.emptyListView.pop_beginTime = CACurrentMediaTime() + delay;
    self.emptyListView.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
    self.emptyListView.pop_spring.alpha = 1.0f;
}

- (void)hideEmptyListView {
    [self hideEmptyListViewAnimated:YES];
}

- (void)hideEmptyListViewAnimated:(BOOL)animated {
    if (animated) {
        self.emptyListView.pop_spring.pop_scaleXY = CGPointMake(kNPREmptyListAnimationScaleValue, kNPREmptyListAnimationScaleValue);
        self.emptyListView.pop_spring.alpha = 0.0f;
    }
    else {
        self.emptyListView.transform = CGAffineTransformMakeScale(kNPREmptyListAnimationScaleValue, kNPREmptyListAnimationScaleValue);
        self.emptyListView.alpha = 0.0f;
    }
}

- (void)showActivityIndicator {
    self.activityIndicatorView.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
    self.activityIndicatorView.pop_spring.alpha = 1.0f;
}

- (void)hideActivityIndicator {
    self.activityIndicatorView.pop_spring.pop_scaleXY = CGPointMake(kNPREmptyListAnimationScaleValue, kNPREmptyListAnimationScaleValue);
    self.activityIndicatorView.pop_spring.alpha = 0.0f;
}

- (void)clearBackgroundColor {
    self.backgroundColor = [UIColor clearColor];
}

- (void)resetBackgroundColor {
    self.backgroundColor = [UIColor npr_redColor];
}

@end
