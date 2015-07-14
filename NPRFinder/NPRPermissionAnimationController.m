//
//  NPRPermissionAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/5/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRPermissionAnimationController.h"

#import "NPRPermissionViewController.h"
#import "NPRPermissionView.h"

@interface NPRPermissionViewController (Transition)

@property (strong, nonatomic) NPRPermissionView *permissionView;

@end

static const CGFloat kNPRPermissionAnimationDuration = 0.75f;

@implementation NPRPermissionAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;

    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

    NPRPermissionViewController *permissionViewController = (NPRPermissionViewController *)fromViewController;
    [permissionViewController.permissionView hideViews];

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRPermissionAnimationDuration;
}

@end
