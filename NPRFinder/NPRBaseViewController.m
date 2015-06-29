//
//  NPRBaseViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRBaseViewController.h"

#import "NPRAppDelegate.h"
#import "NPRAudioManager.h"
#import "NPRAudioPlayerToolbar.h"

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

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerWillShowNotification:) name:kNPRNotificationWillShowAudioPlayerToolbar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerWillHideNotification:) name:kNPRNotificationWillHideAudioPlayerToolbar object:nil];
}

#pragma mark - Actions

- (void)audioPlayerWillShowNotification:(NSNotification *)notification {
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    for (UIView *view in self.navigationController.view.subviews) {
        if ([view isKindOfClass:[NPRAudioPlayerToolbar class]]) {
            [self.navigationController.view bringSubviewToFront:view];
            break;
        }
    }
}

- (void)audioPlayerWillHideNotification:(NSNotification *)notification {
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    for (UIView *view in self.navigationController.view.subviews) {
        if ([view isKindOfClass:[NPRAudioPlayerToolbar class]]) {
            [self.navigationController.view bringSubviewToFront:view];
            break;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNPRNotificationWillShowAudioPlayerToolbar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNPRNotificationWillHideAudioPlayerToolbar object:nil];
}

@end
