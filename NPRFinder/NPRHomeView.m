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

    [self.emptyListView hideAnimated:NO completion:nil];
}

#pragma mark - Setup

- (void)setupHomeCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.itemSize = [NPRStationCell sizeWithWidth:[UIScreen npr_screenWidth]];

    self.homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.homeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.homeCollectionView];

    [self.homeCollectionView npr_fillSuperview];

    self.homeCollectionView.backgroundColor = [UIColor clearColor];
    self.homeCollectionView.showsVerticalScrollIndicator = NO;
    self.homeCollectionView.alwaysBounceVertical = YES;
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
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchButton];

    UIImage *image = [[UIImage imageNamed:@"Search Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    CGFloat width = kNPRPadding + image.size.width;
    CGFloat height = kNPRPadding + image.size.height;
    [self.searchButton npr_pinWidth:width];
    [self.searchButton npr_pinHeight:height];
    self.searchButtonTrailing = [self.searchButton npr_pinTrailingToSuperviewWithPadding:kNPRPadding / 2.0f];
    [self.searchButton npr_pinBottomToSuperviewWithPadding:kNPRPadding / 2.0f];

    self.searchButton.backgroundColor = [UIColor clearColor];
    [self.searchButton setImage:image forState:UIControlStateNormal];
    self.searchButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupEmptyListView {
    self.emptyListView = [[NPREmptyListView alloc] initWithEmptyListText:kNPRHomeEmptyListText
                                                              actionText:kNPRHomeEmptyListActionText
                                                             actionBlock:nil];
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
    self.searchButtonTrailing.pop_spring.constant = kNPRPadding / 2.0f;
}

- (void)hideSearchButton {
    self.searchButtonTrailing.pop_spring.constant = -CGRectGetWidth(self.searchButton.frame);
}

@end
