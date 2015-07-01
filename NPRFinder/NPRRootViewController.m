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

#import "NPRUserDefaults.h"
#import "UIView+NPRAutoLayout.h"

@interface NPRRootViewController () <NPRSplashDelegate, NPRPermissionDelegate>

@property (strong, nonatomic) UIViewController *primaryViewController;

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

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.primaryViewController) {
        [self.primaryViewController willMoveToParentViewController:nil];
        [self.primaryViewController.view removeFromSuperview];
        [self.primaryViewController removeFromParentViewController];
    }

    self.primaryViewController = viewController;

    viewController.modalPresentationStyle = UIModalPresentationCustom;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [viewController didMoveToParentViewController:self];
    [viewController.view npr_fillSuperview];
}

- (void)showSplashViewControllerAnimated:(BOOL)animated {
    NPRSplashViewController *splashViewController = [[NPRSplashViewController alloc] init];
    splashViewController.delegate = self;

    [self showViewController:splashViewController animated:animated];
}

- (void)showPermissionViewControllerAnimated:(BOOL)animated {
    NPRPermissionViewController *permissionViewController = [[NPRPermissionViewController alloc] initWithType:NPRPermissionTypeLocationWhenInUse];
    permissionViewController.delegate = self;

    [self showViewController:permissionViewController animated:animated];
}

- (void)showHomeViewControllerAnimated:(BOOL)animated {
    NPRHomeViewController *homeViewController = [[NPRHomeViewController alloc] init];
    NPRBaseNavigationController *navigationController = [[NPRBaseNavigationController alloc] initWithRootViewController:homeViewController];

    self.transitionController = [[NPRTransitionController alloc] init];
    navigationController.delegate = self.transitionController;

    [self showViewController:navigationController animated:animated];
}

#pragma mark - Splash Delegate

- (void)didFinishAnimatingSplashViewController:(NPRSplashViewController *)splashViewController {
    if (![NPRUserDefaults locationServicesPermissionPrompt]) {
        [NPRUserDefaults setLocationServicesPermissionPrompt:YES];

        [self showPermissionViewControllerAnimated:YES];
    }
    else {
        [self showHomeViewControllerAnimated:YES];
    }
}

#pragma mark - Permission Delegate

- (void)didSelectAcceptForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES];
}

- (void)didSelectDenyForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES];
}

@end
