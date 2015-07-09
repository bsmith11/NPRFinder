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
#import "NPRPermissionView.h"

#import "NPRHomeViewController.h"
#import "NPRHomeView.h"

static const CGFloat kNPRSplashAnimationDuration = 0.75f;

@interface NPRSplashViewController (Transition)

@property (strong, nonatomic) NPRSplashView *splashView;

@end

@interface NPRPermissionViewController (Transition)

@property (strong, nonatomic) NPRPermissionView *permissionView;

@end

@interface NPRHomeViewController (Transition)

@property (strong, nonatomic) NPRHomeView *homeView;

@end

@implementation NPRSplashAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;

    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

    NPRSplashViewController *splashViewController = (NPRSplashViewController *)fromViewController;

    if ([toViewController isKindOfClass:[NPRPermissionViewController class]]) {
        NPRPermissionViewController *permissionViewController = (NPRPermissionViewController *)toViewController;

        [permissionViewController.permissionView showViews];
        [splashViewController.splashView expandRightViewWithCompletion:^(BOOL finished) {
            permissionViewController.permissionView.backgroundView.hidden = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        UINavigationController *navigationController = (UINavigationController *)toViewController;
        NPRHomeViewController *homeViewController = (NPRHomeViewController *)navigationController.topViewController;

        [homeViewController.homeView showSearchButtonWithDelay:0.0f];
        [homeViewController.homeView showActivityIndicator];
        [splashViewController.splashView expandLeftViewWithCompletion:^(BOOL finished) {
            [homeViewController.homeView resetBackgroundColor];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRSplashAnimationDuration;
}

@end
