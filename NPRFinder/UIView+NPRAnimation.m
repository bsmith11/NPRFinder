//
//  UIView+NPRAnimation.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIView+NPRAnimation.h"

#import "NPRAnimationConstants.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

@implementation UIView (NPRAnimation)

- (void)npr_shrinkAnimated:(BOOL)animated {
    [self npr_shrinkAnimated:animated delay:0.0f];
}

- (void)npr_shrinkAnimated:(BOOL)animated delay:(CGFloat)delay {
    if (animated) {
        self.pop_beginTime = CACurrentMediaTime() + delay;
        self.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        self.pop_spring.alpha = 0.0f;
    }
    else {
        self.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        self.alpha = 0.0f;
    }
}

- (void)npr_growAnimated:(BOOL)animated {
    [self npr_growAnimated:animated delay:0.0f];
}

- (void)npr_growAnimated:(BOOL)animated delay:(CGFloat)delay {
    if (animated) {
        self.pop_beginTime = CACurrentMediaTime() + delay;
        self.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
        self.pop_spring.alpha = 1.0f;
    }
    else {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    }
}

@end
