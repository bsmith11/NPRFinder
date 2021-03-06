//
//  NPRTransitionController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/15/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRTransitionController.h"

@implementation NPRTransitionController

- (NPRSlideAnimationController *)slideAnimationController {
    if (!_slideAnimationController) {
        _slideAnimationController = [[NPRSlideAnimationController alloc] init];
    }
    
    return _slideAnimationController;
}

#pragma mark - Navigation Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    BOOL positive = (operation == UINavigationControllerOperationPush);
    self.slideAnimationController.positive = positive;
    
    return self.slideAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.isInteractive ? self.interactionController : nil;
}

#pragma mark - View Controller Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

@end