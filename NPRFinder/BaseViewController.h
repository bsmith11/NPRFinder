//
//  BaseViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseNavigationController;
@class TransitionController;

@interface BaseViewController : UIViewController

@property (assign, nonatomic) CGFloat keyboardHeight;

- (UIImage *)screenshot;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (BaseNavigationController *)baseNavigationController;
- (TransitionController *)transitionController;

@property (strong, nonatomic) UIView *navigationBarContainer;
@property (strong, nonatomic) NSLayoutConstraint *navigationBarContainerHeight;
@property (strong, nonatomic) NSLayoutConstraint *navigationBarContainerTop;

@end
