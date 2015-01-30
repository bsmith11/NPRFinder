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
#import "UIView+NPRConstraints.h"
#import "UIScreen+NPRFinder.h"

@interface BaseViewController ()

@property (strong, nonatomic) NSLayoutConstraint *nprNavigationBarHeight;
@property (strong, nonatomic) NSLayoutConstraint *nprNavigationBarTop;

@end

@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNprNavigationBar];
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

#pragma mark - Setup

- (void)setupNprNavigationBar {
    self.nprNavigationBar = [NPRNavigationBar new];
    [self.nprNavigationBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.nprNavigationBar];
    
    [self.nprNavigationBar addLeadingConstraintToSuperview];
    [self.nprNavigationBar addTrailingConstraintToSuperview];
    self.nprNavigationBarHeight = [self.nprNavigationBar addHeightConstraintWithHeight:[UIScreen npr_navigationBarHeight]];
    self.nprNavigationBarTop = [self.nprNavigationBar addTopConstraintToSuperviewWithConstant:[UIScreen npr_statusBarHeight]];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
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
