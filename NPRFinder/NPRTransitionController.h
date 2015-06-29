//
//  NPRTransitionController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/15/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRSlideAnimationController.h"

@interface NPRTransitionController : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (strong, nonatomic) NPRSlideAnimationController *slideAnimationController;

@property (assign, nonatomic, getter=isInteractive) BOOL interactive;

@end
