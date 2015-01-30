//
//  NPRNavigationBar.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/29/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRNavigationBar.h"
#import "UIScreen+NPRFinder.h"

static const CGFloat kNPRItemMargin = 20.0;
static const CGFloat kNPRItemAnimationDuration = 0.4;

typedef NS_ENUM(NSInteger, NPRItemPosition) {
    NPRItemPositionLeft,
    NPRItemPositionRight,
    NPRItemPositionMiddle
};

@implementation NPRNavigationBar

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

- (void)setLeftItem:(UIView *)leftItem {
    [_leftItem removeFromSuperview];
    _leftItem = leftItem;
    
    [_leftItem sizeToFit];
    
    CGRect frame = [self shownFrameForPosition:NPRItemPositionLeft];
    [_leftItem setFrame:frame];
    
    [self addSubview:_leftItem];
}

- (void)setRightItem:(UIView *)rightItem {
    [_rightItem removeFromSuperview];
    _rightItem = rightItem;
    
    [_rightItem sizeToFit];
    
    CGRect frame = [self shownFrameForPosition:NPRItemPositionRight];
    [_rightItem setFrame:frame];
    
    [self addSubview:_rightItem];
}

- (void)setMiddleItem:(UIView *)middleItem {
    [_middleItem removeFromSuperview];
    _middleItem = middleItem;
    
    [_middleItem sizeToFit];
    
    CGRect frame = [self shownFrameForPosition:NPRItemPositionMiddle];
    [_middleItem setFrame:frame];
    
    [self addSubview:_middleItem];
}

#pragma mark - Animations

- (void)showLeftItemWithAnimation:(NPRItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion {
    [self animateLeftItemWithAnimation:animation
                              animated:animated
                                  show:YES
                            completion:completion];
}

- (void)hideLeftItemWithAnimation:(NPRItemAnimation)animation
                         animated:(BOOL)animated
                       completion:(void (^)(BOOL finished))completion {
    [self animateLeftItemWithAnimation:animation
                              animated:animated
                                  show:NO
                            completion:completion];
}

- (void)animateLeftItemWithAnimation:(NPRItemAnimation)animation
                            animated:(BOOL)animated
                                show:(BOOL)show
                          completion:(void (^)(BOOL))completion {
    [self animateView:self.leftItem
            animation:animation
             position:NPRItemPositionLeft
                 show:show
             animated:animated
           completion:completion];
}

- (void)showRightItemWithAnimation:(NPRItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion {
    [self animateRightItemWithAnimation:animation
                               animated:animated
                                   show:YES
                             completion:completion];
}

- (void)hideRightItemWithAnimation:(NPRItemAnimation)animation
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion {
    [self animateRightItemWithAnimation:animation
                               animated:animated
                                   show:NO
                             completion:completion];
}

- (void)animateRightItemWithAnimation:(NPRItemAnimation)animation
                             animated:(BOOL)animated
                                 show:(BOOL)show
                           completion:(void (^)(BOOL))completion {
    [self animateView:self.rightItem
            animation:animation
             position:NPRItemPositionRight
                 show:show
             animated:animated
           completion:completion];
}

- (void)showMiddleItemWithAnimation:(NPRItemAnimation)animation
                           animated:(BOOL)animated
                         completion:(void (^)(BOOL finished))completion {
    [self animateMiddleItemWithAnimation:animation
                                animated:animated
                                    show:YES
                              completion:completion];
}

- (void)hideMiddleItemWithAnimation:(NPRItemAnimation)animation
                           animated:(BOOL)animated
                         completion:(void (^)(BOOL finished))completion {
    [self animateMiddleItemWithAnimation:animation
                                animated:animated
                                    show:NO
                              completion:completion];
}

- (void)animateMiddleItemWithAnimation:(NPRItemAnimation)animation
                              animated:(BOOL)animated
                                  show:(BOOL)show
                            completion:(void (^)(BOOL))completion {
    [self animateView:self.middleItem
            animation:animation
             position:NPRItemPositionMiddle
                 show:show
             animated:animated
           completion:completion];
}

- (void)animateView:(UIView *)view
          animation:(NPRItemAnimation)animation
           position:(NPRItemPosition)position
               show:(BOOL)show
           animated:(BOOL)animated
         completion:(void (^)(BOOL finished))completion {
    BOOL isFade = (animation == NPRItemAnimationFadeIn || animation == NPRItemAnimationFadeOut);
    CGFloat alpha = (animation == NPRItemAnimationFadeIn) ? 1.0 : 0.0;
    
    CGRect frame;
    if (show) {
        frame = [self shownFrameForPosition:position];
    }
    else {
        frame = [self hiddenFrameForPosition:position
                                   animation:animation];
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect initialWindowFrame = [window convertRect:view.frame fromView:self];
    [view setFrame:initialWindowFrame];
    [view.layer removeAllAnimations];
    
    [window addSubview:view];
    
    CGRect finalWindowFrame = [window convertRect:frame fromView:self];
    
    if (animated) {
        [UIView animateWithDuration:kNPRItemAnimationDuration
                         animations:^{
                             if (isFade) {
                                 [view setAlpha:alpha];
                             }
                             else {
                                 [view setFrame:finalWindowFrame];
                             }
                         }
                         completion:^(BOOL finished) {
                             [view setFrame:frame];
                             [self addSubview:view];
                             
                             if (completion) {
                                 completion(finished);
                             }
                         }];
    }
    else {
        if (isFade) {
            [view setAlpha:alpha];
        }
        else {
            [view setFrame:finalWindowFrame];
        }
        
        [view setFrame:frame];
        [self addSubview:view];
        
        if (completion) {
            completion(YES);
        }
    }
}

- (CGRect)shownFrameForPosition:(NPRItemPosition)position {
    CGRect frame;
    
    switch (position) {
        case NPRItemPositionLeft:
            frame = self.leftItem.frame;
            frame.origin.x = kNPRItemMargin;
            break;
            
        case NPRItemPositionRight:
            frame = self.rightItem.frame;
            frame.origin.x = ([UIScreen npr_screenWidth] - (CGRectGetWidth(frame) + kNPRItemMargin));
            break;
            
        case NPRItemPositionMiddle:
            frame = self.middleItem.frame;
            frame.origin.x = ([UIScreen npr_screenWidth] - CGRectGetWidth(frame)) / 2.0;
            break;
            
        default:
            frame = CGRectZero;
            break;
    }
    
    frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2.0;
    
    return frame;
}

- (CGRect)hiddenFrameForPosition:(NPRItemPosition)position
                       animation:(NPRItemAnimation)animation {
    CGRect frame = [self shownFrameForPosition:position];
    
    switch (animation) {
        case NPRItemAnimationFadeIn:
        case NPRItemAnimationFadeOut:
            break;
            
        case NPRItemAnimationSlideVertically: {
            frame.origin.y = -CGRectGetHeight(frame);
        }
            break;
            
        case NPRItemAnimationSlideHorizontally: {
            if (position == NPRItemPositionLeft) {
                frame.origin.x = -CGRectGetMaxX(frame);
            }
            else if (position == NPRItemPositionRight) {
                frame.origin.x = [UIScreen npr_screenWidth];
            }
        }
            break;
            
        default:
            break;
    }
    
    return frame;
}

@end
