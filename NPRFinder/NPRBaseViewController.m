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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudioPlayerToolbarNotification:) name:kNPRNotificationWillShowAudioPlayerToolbar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudioPlayerToolbarNotification:) name:kNPRNotificationWillHideAudioPlayerToolbar object:nil];
}

#pragma mark - Actions

- (void)didReceiveAudioPlayerToolbarNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat height;
    
    if (userInfo) {
        height = [userInfo[kNPRNotificationKeyAudioPlayerToolbarHeight] doubleValue];
    }
    else {
        height = 0.0f;
    }
    
    [self audioPlayerToolbarHeightWillChange:height];
}

- (void)audioPlayerToolbarHeightWillChange:(CGFloat)height {
    //Should be overrided by subclasses
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNPRNotificationWillShowAudioPlayerToolbar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNPRNotificationWillHideAudioPlayerToolbar object:nil];
}

@end
