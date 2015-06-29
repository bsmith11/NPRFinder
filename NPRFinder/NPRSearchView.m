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

#import <POP+MCAnimate/POP+MCAnimate.h>

static NSString * const kSearchTextFieldPlaceholderText = @"Find stations";

static const CGFloat kNPRAnimationScaleValue = 0.1f;

@interface NPRSearchView ()

@property (strong, nonatomic) NSLayoutConstraint *backgroundViewBottom;

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
    self.backgroundColor = [UIColor npr_redColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self setupBackgroundView];
    [self setupSearchCollectionView];
    [self setupTopBarContainerView];
    [self setupBackButton];
    [self setupSearchTextField];

    self.animatingViews = [NSMutableArray arrayWithArray:@[self.backButton, self.searchTextField]];

    for (UIView *view in self.animatingViews) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }

    self.backgroundViewBottom.constant = [UIScreen npr_screenHeight];
}

#pragma mark - Setup

- (void)setupBackgroundView {
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backgroundView];

    [self.backgroundView npr_fillSuperviewHorizontally];
    [self.backgroundView npr_pinTopToSuperview];
    self.backgroundViewBottom = [self.backgroundView npr_pinBottomToSuperview];

    self.backgroundView.backgroundColor = [UIColor npr_blueColor];
}

- (void)setupSearchCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.itemSize = [NPRStationCell sizeWithWidth:[UIScreen npr_screenWidth]];

    self.searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.searchCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:self.searchCollectionView];

    [self.searchCollectionView npr_fillSuperview];

    self.searchCollectionView.backgroundColor = [UIColor clearColor];
    CGFloat topInset = kNPRPadding + [UIScreen npr_navigationBarHeight];
    self.searchCollectionView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, 0.0f, 0.0f);
    self.searchCollectionView.showsVerticalScrollIndicator = NO;
    self.searchCollectionView.alwaysBounceVertical = YES;
    self.searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.searchCollectionView registerClass:[NPRStationCell class]
                  forCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier]];
}

- (void)setupTopBarContainerView {
    self.topBarContainerView = [[UIView alloc] init];
    self.topBarContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.topBarContainerView];

    [self.topBarContainerView npr_fillSuperviewHorizontally];
    self.topBarContainerViewTop = [self.topBarContainerView npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.topBarContainerView npr_pinHeight:[UIScreen npr_navigationBarHeight]];

    self.topBarContainerView.backgroundColor = [UIColor clearColor];
}

- (void)setupBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topBarContainerView addSubview:self.backButton];

    [self.backButton npr_centerVerticallyInSuperview];
    [self.backButton npr_pinLeadingToSuperviewWithPadding:kNPRPadding];
    [self.backButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setImage:[UIImage imageNamed:@"Back Icon"] forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupSearchTextField {
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topBarContainerView addSubview:self.searchTextField];

    UIImage *image = [self.backButton imageForState:UIControlStateNormal];

    [self.searchTextField npr_pinLeadingToView:self.backButton padding:kNPRPadding];
    [self.searchTextField npr_pinTrailingToSuperviewWithPadding:kNPRPadding];
    [self.searchTextField npr_centerVerticallyWithView:self.backButton];
    [self.searchTextField npr_pinHeight:image.size.height];

    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.textColor = [UIColor npr_blueColor];
    self.searchTextField.font = [UIFont npr_audioPlayerToolbarFont];
    self.searchTextField.textAlignment = NSTextAlignmentLeft;
    self.searchTextField.tintColor = self.searchTextField.textColor;

    NSDictionary *attributes = @{NSFontAttributeName:self.searchTextField.font,
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:kSearchTextFieldPlaceholderText attributes:attributes];
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

- (void)setupActivityIndicatorView {
    self.activityIndicatorView = [[NPRActivityIndicatorView alloc] init];
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicatorView];

    [self.activityIndicatorView npr_centerHorizontallyInSuperview];
    [self.activityIndicatorView npr_centerVerticallyInSuperview];

    self.activityIndicatorView.color = [UIColor npr_foregroundColor];
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

- (void)showBackgroundView {
    self.backgroundViewBottom.pop_springBounciness = 0.0f;
    self.backgroundViewBottom.pop_spring.constant = 0.0f;
}

- (void)hideBackgroundView {
    self.backgroundViewBottom.pop_spring.constant = [UIScreen npr_screenHeight];
}

@end
