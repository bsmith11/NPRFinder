//
//  NPRBaseViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRBaseViewController.h"
#import "NPRAppDelegate.h"

@interface NPRBaseViewController ()

@end

@implementation NPRBaseViewController

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Base Navigation Controller

- (NPRBaseNavigationController *)npr_baseNavigationController {
    if ([self.navigationController isKindOfClass:[NPRBaseNavigationController class]]) {
        return (NPRBaseNavigationController *)self.navigationController;
    }
    else {
        return nil;
    }
}

#pragma mark - Transition Controller

- (NPRTransitionController *)npr_transitionController {
    NPRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    return appDelegate.transitionController;
}

@end
