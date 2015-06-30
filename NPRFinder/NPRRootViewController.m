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

#import "UIView+NPRAutoLayout.h"

@interface NPRRootViewController () <NPRPermissionDelegate>

@property (strong, nonatomic) UIViewController *primaryViewController;

@end

@implementation NPRRootViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NPRPermissionViewController *permissionViewController = [[NPRPermissionViewController alloc] initWithType:NPRPermissionTypeLocationWhenInUse];
    permissionViewController.delegate = self;
    NPRSplashViewController *splashViewController = [[NPRSplashViewController alloc] initWithDismissBlock:^{
        [self showViewController:permissionViewController animated:YES];
    }];
    [self showViewController:splashViewController animated:YES];
}

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

- (void)showHomeViewControllerAnimated:(BOOL)animated {
    NPRHomeViewController *homeViewController = [[NPRHomeViewController alloc] init];
    NPRBaseNavigationController *navigationController = [[NPRBaseNavigationController alloc] initWithRootViewController:homeViewController];

    self.transitionController = [[NPRTransitionController alloc] init];
    navigationController.delegate = self.transitionController;

    [self showViewController:navigationController animated:animated];
}

- (void)didSelectAcceptForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES];
}

- (void)didSelectDenyForPermissionViewController:(NPRPermissionViewController *)permissionViewController {
    [self showHomeViewControllerAnimated:YES];
}

@end
