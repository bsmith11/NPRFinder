//
//  NPRTransitionController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/15/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRExpandAnimationController.h"
#import "NPRSlideAnimationController.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NPRTransitionController : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (strong, nonatomic) NPRSlideAnimationController *slideAnimationController;
@property (strong, nonatomic) NPRExpandAnimationController *expandAnimationController;

@property (assign, nonatomic, getter=isInteractive) BOOL interactive;

@end
