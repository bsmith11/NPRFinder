//
//  TransitionController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/15/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DetailAnimationController;
@class FadeAnimationController;
@class SlideAnimationController;

@interface TransitionController : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (strong, nonatomic) DetailAnimationController *detailAnimationController;
@property (strong, nonatomic) FadeAnimationController *fadeAnimationController;
@property (strong, nonatomic) SlideAnimationController *slideAnimationController;

@property (assign, nonatomic) BOOL isInteractive;

@end
