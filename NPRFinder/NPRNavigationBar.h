//
//  NPRNavigationBar.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/29/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRItemAnimation) {
    NPRItemAnimationFadeIn,
    NPRItemAnimationFadeOut,
    NPRItemAnimationSlideVertically,
    NPRItemAnimationSlideHorizontally,
};

@interface NPRNavigationBar : UIView

@property (strong, nonatomic) UIView *leftItem;
@property (strong, nonatomic) UIView *rightItem;
@property (strong, nonatomic) UIView *middleItem;

- (void)showLeftItemWithAnimation:(NPRItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion;

- (void)hideLeftItemWithAnimation:(NPRItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion;

- (void)showRightItemWithAnimation:(NPRItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion;

- (void)hideRightItemWithAnimation:(NPRItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion;

- (void)showMiddleItemWithAnimation:(NPRItemAnimation)animation
                           animated:(BOOL)animated
                         completion:(void (^)(BOOL finished))completion;

- (void)hideMiddleItemWithAnimation:(NPRItemAnimation)animation
                           animated:(BOOL)animated
                         completion:(void (^)(BOOL finished))completion;

@end
