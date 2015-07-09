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

#import "NPRUserDefaults.h"
#import "UIView+NPRAutoLayout.h"

@interface NPRRootViewController () <NPRSplashDelegate, NPRPermissionDelegate>

@property (strong, nonatomic) UIViewController *primaryViewController;
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
    
    [self showSplashViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)showSplashViewControllerAnimated:(BOOL)animated {
    self.splashViewController = [[NPRSplashViewController alloc] init];
    self.splashViewController.delegate = self;

    self.splashViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self addChildViewController:self.splashViewController];
    [self.view addSubview:self.splashViewController.view];
    self.splashViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.splashViewController didMoveToParentViewController:self];
    [self.splashViewController.view npr_fillSuperview];
}

- (void)showPermissionViewControllerAnimated:(BOOL)animated {
    self.permissionViewController = [[NPRPermissionViewController alloc] initWithType:NPRPermissionTypeLocationWhenInUse];
    self.permissionViewController.delegate = self;

    [self.splashViewController willMoveToParentViewController:nil];
    [self addChildViewController:self.permissionViewController];

    NPRSplashAnimationController *animator = [[NPRSplashAnimationController alloc] init];

    NPRTransitionContext *transitionContext = [[NPRTransitionContext alloc] initWithFromViewController:self.splashViewController toViewController:self.permissionViewController];

    transitionContext.completion = ^(BOOL finished) {
        [self.splashViewController.view removeFromSuperview];
        [self.splashViewController removeFromParentViewController];
        [self.permissionViewController didMoveToParentViewController:self];
    };

    [animator animateTransition:transitionContext];
}

- (void)showHomeViewControllerAnimated:(BOOL)animated fromViewController:(UIViewController *)fromViewController {
    id <UIViewControllerAnimatedTransitioning> animator;
    BOOL clearBackground;
    if ([fromViewController isKindOfClass:[NPRSplashViewController class]]) {
        clearBackground = YES;
        animator = [[NPRSplashAnimationController alloc] init];
    }
    else {
        clearBackground = NO;
        animator = [[NPRPermissionAnimationController alloc] init];
    }

    NPRHomeViewModel *homeViewModel = [[NPRHomeViewModel alloc] init];
    self.homeViewController = [[NPRHomeViewController alloc] initWithHomeViewModel:homeViewModel clearBackground:clearBackground];
    NPRBaseNavigationController *navigationController = [[NPRBaseNavigationController alloc] initWithRootViewController:self.homeViewController];
    self.transitionController = [[NPRTransitionController alloc] init];
    navigationController.delegate = self.transitionController;

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:navigationController];

    NPRTransitionContext *transitionContext = [[NPRTransitionContext alloc] initWithFromViewController:fromViewController toViewController:navigationController];

    transitionContext.completion = ^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [navigationController didMoveToParentViewController:self];
    };

    [animator animateTransition:transitionContext];
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
