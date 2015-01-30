//
//  BaseViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPRNavigationBar.h"

@class BaseNavigationController;
@class TransitionController;

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NPRNavigationBar *nprNavigationBar;

@property (assign, nonatomic) CGFloat keyboardHeight;

- (UIImage *)screenshot;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (BaseNavigationController *)baseNavigationController;
- (TransitionController *)transitionController;

@end
