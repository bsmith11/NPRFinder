//
//  UINavigationItem+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRBarButtonItemAnimation) {
    NPRBarButtonItemAnimationFadeIn,
    NPRBarButtonItemAnimationFadeOut,
    NPRBarButtonItemAnimationSlideVertically,
    NPRBarButtonItemAnimationSlideHorizontally,
};

@interface UINavigationItem (NPRFinder)

- (void)showLeftItemWithAnimation:(NPRBarButtonItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion;

- (void)hideLeftItemWithAnimation:(NPRBarButtonItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion;

- (void)showRightItemWithAnimation:(NPRBarButtonItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion;

- (void)hideRightItemWithAnimation:(NPRBarButtonItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion;

@end
