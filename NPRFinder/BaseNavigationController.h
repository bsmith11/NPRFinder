//
//  BaseNavigationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/14/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRNavigationBarAnimation) {
    NPRNavigationBarAnimationFade,
    NPRNavigationBarAnimationSlide,
    NPRNavigationBarAnimationNone
};

typedef NS_ENUM(NSInteger, NPRNavigationBarAnimationDirection) {
    NPRNavigationBarAnimationDirectionVertical,
    NPRNavigationBarAnimationDirectionHorizontal,
    NPRNavigationBarAnimationDirectionNone
};

@interface BaseNavigationController : UINavigationController

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIView *navigationBarContainer;
@property (strong, nonatomic) NSLayoutConstraint *navigationBarContainerHeight;
@property (strong, nonatomic) NSLayoutConstraint *navigationBarContainerTop;
@property (strong, nonatomic) UIView *navigationBarLeftItem;
@property (strong, nonatomic) UIView *navigationBarRightItem;
@property (strong, nonatomic) UIView *navigationBarLeftTitle;
@property (strong, nonatomic) UIView *navigationBarTitle;

- (void)showLeftItemWithAnimation:(NPRNavigationBarAnimation)animation
                        direction:(NPRNavigationBarAnimationDirection)direction
                       completion:(void (^)(BOOL finished))completion;

- (void)hideLeftItemWithAnimation:(NPRNavigationBarAnimation)animation
                        direction:(NPRNavigationBarAnimationDirection)direction
                       completion:(void (^)(BOOL finished))completion;

- (void)showRightItemWithAnimation:(NPRNavigationBarAnimation)animation
                         direction:(NPRNavigationBarAnimationDirection)direction
                        completion:(void (^)(BOOL finished))completion;

- (void)hideRightItemWithAnimation:(NPRNavigationBarAnimation)animation
                         direction:(NPRNavigationBarAnimationDirection)direction
                        completion:(void (^)(BOOL finished))completion;

@end
