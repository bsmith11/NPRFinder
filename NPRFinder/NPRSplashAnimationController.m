//
//  NPRSplashAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/5/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSplashAnimationController.h"

#import "NPRSplashViewController.h"
#import "NPRSplashView.h"
#import "NPRPermissionViewController.h"

static const CGFloat kNPRSplashAnimationDuration = 0.75f;

@interface NPRSplashViewController (Transition)

@property (strong, nonatomic) NPRSplashView *splashView;

@end

@implementation NPRSplashAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;

    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

    NPRSplashViewController *splashViewController = (NPRSplashViewController *)fromViewController;

    if ([toViewController isKindOfClass:[NPRPermissionViewController class]]) {
        [splashViewController.splashView expandRightViewWithCompletion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        [splashViewController.splashView expandLeftViewWithCompletion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRSplashAnimationDuration;
}

@end
