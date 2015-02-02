//
//  DetailInteractionController.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/2/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "DetailInteractionController.h"

@interface DetailInteractionController ()

@property (weak, nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation DetailInteractionController

#pragma mark - View Controller Interactive Transitioning Delegate

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    [self.transitionContext updateInteractiveTransition:percentComplete];
}

- (void)finishInteractiveTransition {
    [self.transitionContext finishInteractiveTransition];
}

- (void)cancelInteractiveTransition {
    [self.transitionContext cancelInteractiveTransition];
}

@end
