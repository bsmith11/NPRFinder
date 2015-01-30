//
//  BaseNavigationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/14/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+NPRFinder.h"
#import "UIView+NPRConstraints.h"
#import "UIScreen+NPRFinder.h"

static const CGFloat kNavigationBarItemWidth = 66.0;
static const CGFloat kNavigationBarLeftTitleMargin = 20.0;

static const CGFloat kNavigationBarItemAnimationDuration = 0.4;

@implementation BaseNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setNavigationBarHidden:YES animated:NO];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationBar setTranslucent:YES];
    
    [self setupBackgroundImageView];
//    [self setupNavigationBarContainer];
}

- (void)setNavigationBarLeftItem:(UIView *)navigationBarLeftItem {
    [_navigationBarContainer removeConstraintsForSubview:_navigationBarLeftItem];
    [_navigationBarLeftItem removeFromSuperview];
    
    _navigationBarLeftItem = navigationBarLeftItem;
    [_navigationBarLeftItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_navigationBarContainer addSubview:_navigationBarLeftItem];
    
    [_navigationBarLeftItem addWidthConstraintWithWidth:kNavigationBarItemWidth];
    [_navigationBarLeftItem addTopConstraintToSuperview];
    [_navigationBarLeftItem addBottomConstraintToSuperview];
    [_navigationBarLeftItem addLeadingConstraintToSuperview];
}

- (void)setNavigationBarRightItem:(UIView *)navigationBarRightItem {
    [_navigationBarContainer removeConstraintsForSubview:_navigationBarRightItem];
    [_navigationBarRightItem removeFromSuperview];
    
    _navigationBarRightItem = navigationBarRightItem;
    [_navigationBarRightItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_navigationBarContainer addSubview:_navigationBarRightItem];
    
    [_navigationBarRightItem addWidthConstraintWithWidth:kNavigationBarItemWidth];
    [_navigationBarRightItem addTopConstraintToSuperview];
    [_navigationBarRightItem addBottomConstraintToSuperview];
    [_navigationBarRightItem addTrailingConstraintToSuperview];
}

- (void)setNavigationBarLeftTitle:(UIView *)navigationBarLeftTitle {
    [_navigationBarContainer removeConstraintsForSubview:_navigationBarLeftTitle];
    [_navigationBarLeftTitle removeFromSuperview];
    
    _navigationBarLeftTitle = navigationBarLeftTitle;
    [_navigationBarLeftTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_navigationBarContainer addSubview:_navigationBarLeftTitle];
    
    [_navigationBarLeftTitle addTopConstraintToSuperview];
    [_navigationBarLeftTitle addBottomConstraintToSuperview];
    [_navigationBarLeftTitle addLeadingConstraintToSuperviewWithConstant:kNavigationBarLeftTitleMargin];
}

- (void)setNavigationBarTitle:(UIView *)navigationBarTitle {
    [_navigationBarContainer removeConstraintsForSubview:_navigationBarTitle];
    [_navigationBarTitle removeFromSuperview];
    
    _navigationBarTitle = navigationBarTitle;
    [_navigationBarTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_navigationBarContainer addSubview:_navigationBarTitle];
    
    [_navigationBarTitle addTopConstraintToSuperview];
    [_navigationBarTitle addBottomConstraintToSuperview];
    [_navigationBarTitle addConstraint:[NSLayoutConstraint constraintWithItem:_navigationBarTitle.superview
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_navigationBarTitle
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0]];
}

#pragma mark - Setup

- (void)setupNavigationBarContainer {
    self.navigationBarContainer = [UIView new];
    [self.navigationBarContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navigationBarContainer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.navigationBarContainer];
    
    [self.navigationBarContainer addLeadingConstraintToSuperview];
    [self.navigationBarContainer addTrailingConstraintToSuperview];
    self.navigationBarContainerHeight = [self.navigationBarContainer addHeightConstraintWithHeight:[UIScreen npr_navigationBarHeight]];
    self.navigationBarContainerTop = [self.navigationBarContainer addTopConstraintToSuperviewWithConstant:[UIScreen npr_statusBarHeight]];
}

- (void)setupBackgroundImageView {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage npr_backgroundImage]];
    [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    
    [self.backgroundImageView addTopConstraintToSuperview];
    [self.backgroundImageView addLeadingConstraintToSuperview];
    [self.backgroundImageView addTrailingConstraintToSuperview];
    [self.backgroundImageView addBottomConstraintToSuperview];
}

#pragma mark - Animations

- (void)showLeftItemWithAnimation:(NPRNavigationBarAnimation)animation
                        direction:(NPRNavigationBarAnimationDirection)direction
                       completion:(void (^)(BOOL finished))completion {
    NSLayoutConstraint *constraint;
    CGFloat constant;
    UIView *view = self.navigationBarLeftItem;
    
    if (direction == NPRNavigationBarAnimationDirectionHorizontal) {
        constraint = [view leadingConstraintWithSuperview];
        constant = 0.0;
    }
    else if (direction == NPRNavigationBarAnimationDirectionVertical) {
        constraint = [view topConstraintWithSuperview];
        constant = 0.0;
    }
    else {
        constraint = nil;
        constant = 1.0;
    }
    
    [self animateView:view
            animation:animation
           constraint:constraint
             constant:constant
           completion:completion];
}

- (void)hideLeftItemWithAnimation:(NPRNavigationBarAnimation)animation
                        direction:(NPRNavigationBarAnimationDirection)direction
                       completion:(void (^)(BOOL finished))completion {
    NSLayoutConstraint *constraint;
    CGFloat constant;
    UIView *view = self.navigationBarLeftItem;
    
    if (direction == NPRNavigationBarAnimationDirectionHorizontal) {
        constraint = [view leadingConstraintWithSuperview];
        constant = -CGRectGetWidth(view.frame);
    }
    else if (direction == NPRNavigationBarAnimationDirectionVertical) {
        constraint = [view topConstraintWithSuperview];
        constant = -CGRectGetHeight(view.frame);
    }
    else {
        constraint = nil;
        constant = 0.0;
    }
    
    [self animateView:view
            animation:animation
           constraint:constraint
             constant:constant
           completion:completion];
}

- (void)showRightItemWithAnimation:(NPRNavigationBarAnimation)animation
                         direction:(NPRNavigationBarAnimationDirection)direction
                        completion:(void (^)(BOOL finished))completion {
    NSLayoutConstraint *constraint;
    CGFloat constant;
    UIView *view = self.navigationBarRightItem;
    
    if (direction == NPRNavigationBarAnimationDirectionHorizontal) {
        constraint = [view trailingConstraintWithSuperview];
        constant = 0.0;
    }
    else if (direction == NPRNavigationBarAnimationDirectionVertical) {
        constraint = [view topConstraintWithSuperview];
        constant = 0.0;
    }
    else {
        constraint = nil;
        constant = 1.0;
    }
    
    [self animateView:view
            animation:animation
           constraint:constraint
             constant:constant
           completion:completion];
}

- (void)hideRightItemWithAnimation:(NPRNavigationBarAnimation)animation
                         direction:(NPRNavigationBarAnimationDirection)direction
                        completion:(void (^)(BOOL finished))completion {
    NSLayoutConstraint *constraint;
    CGFloat constant;
    UIView *view = self.navigationBarRightItem;
    
    if (direction == NPRNavigationBarAnimationDirectionHorizontal) {
        constraint = [view trailingConstraintWithSuperview];
        constant = -CGRectGetWidth(view.frame);
    }
    else if (direction == NPRNavigationBarAnimationDirectionVertical) {
        constraint = [view topConstraintWithSuperview];
        constant = -CGRectGetHeight(view.frame);
    }
    else {
        constraint = nil;
        constant = 0.0;
    }
    
    [self animateView:view
            animation:animation
           constraint:constraint
             constant:constant
           completion:completion];
}

- (void)animateView:(UIView *)view
          animation:(NPRNavigationBarAnimation)animation
         constraint:(NSLayoutConstraint *)constraint
           constant:(CGFloat)constant
         completion:(void (^)(BOOL finished))completion {
    switch (animation) {
        case NPRNavigationBarAnimationFade: {
            [UIView animateWithDuration:kNavigationBarItemAnimationDuration
                             animations:^{
                                 [view setAlpha:constant];
                             }
                             completion:completion];
        }
            break;
            
        case NPRNavigationBarAnimationSlide: {
            [UIView animateWithDuration:kNavigationBarItemAnimationDuration
                             animations:^{
                                 [constraint setConstant:constant];
                                 [self.view layoutIfNeeded];
                             }
                             completion:completion];
        }
            break;
            
        case NPRNavigationBarAnimationNone: {
            [constraint setConstant:constant];
            
            if (completion) {
                completion(YES);
            }
        }
            break;
            
        default:
            break;
    }
}

@end
