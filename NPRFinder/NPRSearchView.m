//
//  NPRSearchView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSearchView.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIView+NPRAutoLayout.h"
#import "NPRStationCell.h"
#import "UIScreen+NPRUtil.h"
#import "NPRStyleConstants.h"
#import "NPRCollectionViewLayout.h"
#import "NPRAnimationConstants.h"

#import <POP+MCAnimate/POP+MCAnimate.h>
#import <RZUtils/RZCommonUtils.h>

static NSString * const kNPRSearchTextFieldPlaceholderText = @"Find stations";

@interface NPRSearchView ()

@property (strong, nonatomic) NSLayoutConstraint *backButtonTop;
@property (strong, nonatomic) NSLayoutConstraint *searchTextFieldTop;

@end

@implementation NPRSearchView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self setupSearchCollectionView];
    [self setupBackButton];
    [self setupSearchTextField];
    [self setupEmptyListView];
    [self setupActivityIndicatorView];

    self.animatingViews = [NSMutableArray arrayWithArray:@[self.backButton, self.searchTextField]];

    for (UIView *view in self.animatingViews) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }

    [self hideEmptyListViewAnimated:NO];
}

#pragma mark - Setup

- (void)setupSearchCollectionView {
    NPRCollectionViewLayout *layout = [[NPRCollectionViewLayout alloc] init];
    self.searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.searchCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchCollectionView];

    [self.searchCollectionView npr_fillSuperview];

    self.searchCollectionView.backgroundColor = [UIColor clearColor];
    CGFloat topInset = kNPRPadding + [UIScreen npr_navigationBarHeight];
    self.searchCollectionView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, 0.0f, 0.0f);
    self.searchCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.searchCollectionView.alwaysBounceVertical = YES;
    self.searchCollectionView.delaysContentTouches = NO;
    self.searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.searchCollectionView registerClass:[NPRStationCell class]
                  forCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier]];
}

- (void)setupBackButton {
    self.backButton = [[NPRButton alloc] init];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backButton];

    self.backButtonTop = [self.backButton npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.backButton npr_pinLeadingToSuperviewWithPadding:kNPRPadding];
    [self.backButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    self.backButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[UIImage imageNamed:@"Back Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:image forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor npr_foregroundColor];
    self.backButton.slopInset = UIEdgeInsetsMake(kNPRPadding, kNPRPadding, kNPRPadding, kNPRPadding);
}

- (void)setupSearchTextField {
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.searchTextField];

    UIImage *image = [self.backButton imageForState:UIControlStateNormal];

    self.searchTextFieldTop = [self.searchTextField npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.searchTextField npr_pinLeadingToView:self.backButton padding:kNPRPadding];
    [self.searchTextField npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
    [self.searchTextField npr_pinHeight:image.size.height];

    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.textColor = [UIColor npr_blueColor];
    self.searchTextField.font = [UIFont npr_audioPlayerToolbarFont];
    self.searchTextField.textAlignment = NSTextAlignmentLeft;
    self.searchTextField.tintColor = self.searchTextField.textColor;

    NSDictionary *attributes = @{NSFontAttributeName:self.searchTextField.font,
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:kNPRSearchTextFieldPlaceholderText attributes:attributes];
    self.searchTextField.attributedPlaceholder = attributedPlaceholder;

    CGRect frame = CGRectMake(0.0f, 0.0f, kNPRPadding, image.size.height);
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    UIView *rightView = [[UIView alloc] initWithFrame:frame];

    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.rightView = rightView;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;

    self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchTextField.adjustsFontSizeToFitWidth = NO;
    self.searchTextField.layer.cornerRadius = kNPRPadding;
    self.searchTextField.clipsToBounds = YES;
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

- (void)adjustTopItemsForContentOffset:(CGPoint)contentOffset {
    CGFloat minValue = -CGRectGetHeight(self.backButton.frame) - self.searchCollectionView.contentInset.top;
    CGFloat maxValue = kNPRPadding;
    CGFloat adjustedValue = -(contentOffset.y + self.searchCollectionView.contentInset.top) + maxValue;
    adjustedValue = RZClampFloat(adjustedValue, minValue, maxValue);

    if (self.backButtonTop.constant != adjustedValue) {
        self.backButtonTop.constant = adjustedValue;
        self.searchTextFieldTop.constant = adjustedValue;
    }
}

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

- (void)showEmptyListView {
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

@end
