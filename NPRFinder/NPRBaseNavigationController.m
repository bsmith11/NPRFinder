//
//  NPRBaseNavigationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/14/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRBaseNavigationController.h"

@implementation NPRBaseNavigationController

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.toolbar setTranslucent:NO];
    [self.toolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny];
    
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];    
}

@end
