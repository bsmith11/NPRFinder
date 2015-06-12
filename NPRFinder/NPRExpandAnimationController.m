//
//  NPRExpandAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRExpandAnimationController.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>

static const CGFloat kNPRExpandAnimationDuration = 0.3f;

@implementation NPRExpandAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    CGRect startFrame;
    CGRect endFrame;
    UIView *animatingView;
    
    if (self.isPositive) {
        [containerView addSubview:toViewController.view];
        animatingView = toViewController.view;
        
        startFrame = [containerView convertRect:self.expandingView.frame fromView:self.expandingView.superview];
        endFrame = [UIScreen mainScreen].bounds;
    }
    else {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        animatingView = fromViewController.view;
        
        endFrame = [containerView convertRect:self.expandingView.frame fromView:self.expandingView.superview];
        startFrame = animatingView.frame;
    }
    
    animatingView.frame = startFrame;
    animatingView.pop_duration = [self transitionDuration:transitionContext];
    animatingView.pop_springBounciness = 0.0f;
    animatingView.pop_springSpeed = 10.0f;
    
    [NSObject pop_animate:^{
        animatingView.pop_spring.frame = endFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRExpandAnimationDuration;
}

@end
