//
//  UINavigationItem+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UINavigationItem+NPRFinder.h"
#import "UIScreen+NPRFinder.h"

typedef NS_ENUM(NSInteger, NPRBarButtonItemPosition) {
    NPRBarButtonItemPositionLeft,
    NPRBarButtonItemPositionRight
};

@implementation UINavigationItem (NPRFinder)

- (void)showLeftItemWithAnimation:(NPRBarButtonItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion {
    [self animateLeftItemWithAnimation:animation
                              animated:animated
                                  show:YES
                            completion:completion];
}

- (void)hideLeftItemWithAnimation:(NPRBarButtonItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion {
    [self animateLeftItemWithAnimation:animation
                              animated:animated
                                  show:NO
                            completion:completion];
}

- (void)animateLeftItemWithAnimation:(NPRBarButtonItemAnimation)animation
                            animated:(BOOL)animated
                                show:(BOOL)show
                          completion:(void (^)(BOOL))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *customView = self.leftBarButtonItem.customView;
//    UIView *snapshot = [customView snapshotViewAfterScreenUpdates:NO];
    NPRBarButtonItemPosition position = NPRBarButtonItemPositionLeft;
    
    CGRect shownFrame = [self shownFrameForPosition:position];
    CGRect hiddenFrame = [self hiddenFrameForPosition:position
                                            animation:animation];
    
    CGRect frame = show ? hiddenFrame : shownFrame;
    
//    [snapshot setFrame:frame];
//    [snapshot.layer removeAllAnimations];
    [window addSubview:customView];
    
    [self animateView:customView
            animation:animation
             position:position
           shownFrame:shownFrame
          hiddenFrame:hiddenFrame
                 show:show
             animated:animated
           completion:^(BOOL finished) {
               [customView removeFromSuperview];
               [self setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customView] animated:NO];
               
               if (completion) {
                   completion(finished);
               }
           }];
}

- (void)showRightItemWithAnimation:(NPRBarButtonItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion {
    [self animateRightItemWithAnimation:animation
                               animated:animated
                                   show:YES
                             completion:completion];
}

- (void)hideRightItemWithAnimation:(NPRBarButtonItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion {
    [self animateRightItemWithAnimation:animation
                               animated:animated
                                   show:NO
                             completion:completion];
}

- (void)animateRightItemWithAnimation:(NPRBarButtonItemAnimation)animation
                             animated:(BOOL)animated
                                 show:(BOOL)show
                           completion:(void (^)(BOOL))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *customView = self.rightBarButtonItem.customView;
    NPRBarButtonItemPosition position = NPRBarButtonItemPositionRight;
    
    CGRect shownFrame = [self shownFrameForPosition:position];
    CGRect hiddenFrame = [self hiddenFrameForPosition:position
                                            animation:animation];
    
    CGRect frame = show ? hiddenFrame : shownFrame;
    
    [self setRightBarButtonItem:nil];
//    [self.rightBarButtonItem setCustomView:[UIView new]];
    
    [customView setFrame:frame];
    [customView.layer removeAllAnimations];
    [window addSubview:customView];
    
    [self animateView:customView
            animation:animation
             position:position
           shownFrame:shownFrame
          hiddenFrame:hiddenFrame
                 show:show
             animated:animated
           completion:^(BOOL finished) {
               [customView removeFromSuperview];
               [customView setFrame:CGRectMake(0, 0, 44.0, 44.0)];
               UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
//               [self.rightBarButtonItem setCustomView:customView];
               [self setRightBarButtonItem:item];
               
               if (completion) {
                   completion(finished);
               }
           }];
}

- (void)animateView:(UIView *)view
          animation:(NPRBarButtonItemAnimation)animation
           position:(NPRBarButtonItemPosition)position
         shownFrame:(CGRect)shownFrame
        hiddenFrame:(CGRect)hiddenFrame
               show:(BOOL)show
           animated:(BOOL)animated
         completion:(void (^)(BOOL finished))completion {
    CGRect frame = view.frame;
    BOOL isFade = (animation == NPRBarButtonItemAnimationFadeIn || animation == NPRBarButtonItemAnimationFadeOut);
    CGFloat alpha = (animation == NPRBarButtonItemAnimationFadeIn) ? 1.0 : 0.0;
    
    if (show) {
        frame = shownFrame;
    }
    else {
        frame = hiddenFrame;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             if (isFade) {
                                 [view setAlpha:alpha];
                             }
                             else {
                                 [view setFrame:frame];
                             }
                         }
                         completion:completion];
    }
    else {
        if (isFade) {
            [view setAlpha:alpha];
        }
        else {
            [view setFrame:frame];
        }
        
        if (completion) {
            completion(YES);
        }
    }
}

- (CGRect)shownFrameForPosition:(NPRBarButtonItemPosition)position {
    UIView *customView;
    if (position == NPRBarButtonItemPositionLeft) {
        customView = self.leftBarButtonItem.customView;
    }
    else {
        customView = self.rightBarButtonItem.customView;
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect frame = [window convertRect:customView.frame fromView:customView.superview];
    
    return frame;
}

- (CGRect)hiddenFrameForPosition:(NPRBarButtonItemPosition)position
                       animation:(NPRBarButtonItemAnimation)animation {
    CGRect frame = [self shownFrameForPosition:position];
    
    switch (animation) {
        case NPRBarButtonItemAnimationFadeIn:
        case NPRBarButtonItemAnimationFadeOut:
            break;
            
        case NPRBarButtonItemAnimationSlideVertically: {
            frame.origin.y += -([UIScreen npr_navigationBarHeight] + [UIScreen npr_statusBarHeight]);
        }
            break;
            
        case NPRBarButtonItemAnimationSlideHorizontally: {
            if (position == NPRBarButtonItemPositionLeft) {
                frame.origin.x += -CGRectGetMaxX(frame);
            }
            else if (position == NPRBarButtonItemPositionRight) {
                frame.origin.x += ([UIScreen npr_screenWidth] - CGRectGetMinX(frame));
            }
        }
            break;
            
        default:
            break;
    }
    
    return frame;
}

@end
