//
//  FadeAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "FadeAnimationController.h"

static const CGFloat kFadeAnimationDurationIn = 0.75;
static const CGFloat kFadeAnimationDurationOut = 0.75;
static const CGFloat kFadeAnimationSpringDampingValue = 1.0;
static const CGFloat kFadeAnimationInitialSpringVelocityValue = 1.0;

@implementation FadeAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    CGFloat initialFromAlpha;
    CGFloat endFromAlpha;
    
    CGFloat initialToAlpha;
    CGFloat endToAlpha;
    
    if (self.fadeDirection == FadeDirectionIn) {
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        
        initialFromAlpha = 1.0;
        endFromAlpha = 1.0;
        
        initialToAlpha = 0.0;
        endToAlpha = 1.0;
    }
    else {
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];
        
        initialFromAlpha = 1.0;
        endFromAlpha = 0.0;
        
        initialToAlpha = 1.0;
        endToAlpha = 1.0;
    }
    
    [fromViewController.view setAlpha:initialFromAlpha];
    [toViewController.view setAlpha:initialToAlpha];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:kFadeAnimationSpringDampingValue
          initialSpringVelocity:kFadeAnimationInitialSpringVelocityValue
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [fromViewController.view setAlpha:endFromAlpha];
                         [toViewController.view setAlpha:endToAlpha];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.fadeDirection == FadeDirectionIn) {
        return kFadeAnimationDurationIn;
    }
    else {
        return kFadeAnimationDurationOut;
    }
}

@end

