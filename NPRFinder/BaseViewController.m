//
//  BaseViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+ImageEffects.h"
#import "BaseNavigationController.h"
#import "TransitionController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBarContainer setHidden:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotifications];
}

#pragma mark - Base Navigation Controller

- (BaseNavigationController *)baseNavigationController {
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        return (BaseNavigationController *)self.navigationController;
    }
    else {
        return nil;
    }
}

#pragma mark - Transition Controller

- (TransitionController *)transitionController {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    return appDelegate.transitionController;
}

#pragma mark - Screenshot

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.navigationController.view.bounds.size, NO, 0);
    [self.navigationController.view drawViewHierarchyInRect:self.navigationController.view.bounds afterScreenUpdates:NO];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [screenshot applyBackgroundBlurEffect];
}

#pragma mark - Keyboard Notifications

- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Actions

- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endKeyboardFrame = [((NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey]) CGRectValue];
    
    self.keyboardHeight = CGRectGetHeight(endKeyboardFrame);
}

@end
