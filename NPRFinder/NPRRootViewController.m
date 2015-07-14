//
//  NPRRootViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/29/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRRootViewController.h"

#import "NPRSplashViewController.h"
#import "NPRPermissionViewController.h"
#import "NPRHomeViewController.h"
#import "NPRTransitionController.h"
#import "NPRTransitionContext.h"
#import "NPRPermissionAnimationController.h"
#import "NPRSplashAnimationController.h"

#import "UIColor+NPRStyle.h"
#import "NPRUserDefaults.h"
#import "UIView+NPRAutoLayout.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

@interface NPRRootViewController () <NPRSplashDelegate, NPRPermissionDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) NSLayoutConstraint *backgroundViewTop;
@property (strong, nonatomic) NPRSplashViewController *splashViewController;
@property (strong, nonatomic) NPRPermissionViewController *permissionViewController;
@property (strong, nonatomic) NPRHomeViewController *homeViewController;

@end

@implementation NPRRootViewController

#pragma mark - Lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor npr_redColor];

    [self setupBackgroundView];
    [self showSplashViewControllerAnimated:YES];
}

#pragma mark - Setup

- (void)setupBackgroundView {
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundView];

    self.backgroundViewTop = [self.backgroundView npr_pinTopToSuperview];
    [self.backgroundView npr_pinBottomToSuperview];
    [self.backgroundView npr_fillSuperviewHorizontally];

    self.backgroundView.backgroundColor = [UIColor npr_blueColor];
    self.backgroundView.hidden = YES;
}

#pragma mark - Actions

- (void)showSplashViewControllerAnimated:(BOOL)animated {
    self.splashViewController = [[NPRSplashViewController alloc] init];
    self.splashViewController.delegate = self;

    [self showViewController:self.splashViewController];
}

- (void)showPermissionViewControllerAnimated:(BOOL)animated {
    self.permissionViewController = [[NPRPermissionViewController alloc] initWithType:NPRPermissionTypeLocationWhenInUse];
    self.permissionViewController.delegate = self;
    NPRSplashAnimationController *animationController = [[NPRSplashAnimationController alloc] init];

    [self transitionFromViewController:self.splashViewController
                      toViewController:self.permissionViewController
                   animationController:animationController
                            completion:^(BOOL finished) {
                                self.backgroundView.hidden = NO;
                            }];
}

- (void)showHomeViewControllerAnimated:(BOOL)animated fromViewController:(UIViewController *)fromViewController {
    id <UIViewControllerAnimatedTransitioning> animationController;
    if ([fromViewController isKindOfClass:[NPRSplashViewController class]]) {
        animationController = [[NPRSplashAnimationController alloc] init];
    }
    else {
        animationController = [[NPRPermissionAnimationController alloc] init];
    }

    NPRHomeViewModel *homeViewModel = [[NPRHomeViewModel alloc] init];
    self.homeViewController = [[NPRHomeViewController alloc] initWithHomeViewModel:homeViewModel];
    NPRBaseNavigationController *navigationController = [[NPRBaseNavigationController alloc] initWithRootViewController:self.homeViewController];
    self.transitionController = [[NPRTransitionController alloc] init];
    navigationController.delegate = self.transitionController;

    [self transitionFromViewController:fromViewController
                      toViewController:navigationController
                   animationController:animationController
                            completion:nil];

    if ([fromViewController isKindOfClass:[NPRPermissionViewController class]]) {
        self.backgroundViewTop.pop_springBounciness = 0.0f;
        self.backgroundViewTop.pop_spring.constant = CGRectGetHeight(self.backgroundView.frame);
    }
}

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                 animationController:(id <UIViewControllerAnimatedTransitioning>)animationController
                          completion:(void (^)(BOOL finished))completion {
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    NPRTransitionContext *transitionContext = [[NPRTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController containerView:self.view];

    transitionContext.completion = ^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];

        if (completion) {
            completion(finished);
        }
    };

    [animationController animateTransition:transitionContext];
}

- (void)showViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [viewController.view npr_fillSuperview];
}

#pragma mark - Splash Delegate

- (void)didFinishAnimatingSplashViewController:(NPRSplashViewController *)splashViewController {
    if (![NPRUserDefaults locationServicesPermissionPrompt]) {
        [NPRUserDefaults setLocationServicesPermissionPrompt:YES];

        [self showPermissionViewControllerAnimated:YES];
    }
    else {
        [self showHomeViewControllerAnimated:YES fromViewController:self.splashViewController];
    }
}

#pragma mark - Permission Delegate

- (void)didSelectAcceptForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES fromViewController:permissionViewController];
}

- (void)didSelectDenyForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES fromViewController:permissionViewController];
}

@end
