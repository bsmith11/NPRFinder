//
//  TransitionController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/15/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "TransitionController.h"
#import "FadeAnimationController.h"
#import "DetailAnimationController.h"
#import "SlideAnimationController.h"
#import "SearchViewController.h"
#import "ProgramsViewController.h"

@interface TransitionController ()

@end

@implementation TransitionController

- (DetailAnimationController *)detailAnimationController {
    if (!_detailAnimationController) {
        _detailAnimationController = [DetailAnimationController new];
    }
    
    return _detailAnimationController;
}

- (FadeAnimationController *)fadeAnimationController {
    if (!_fadeAnimationController) {
        _fadeAnimationController = [FadeAnimationController new];
    }
    
    return _fadeAnimationController;
}

- (SlideAnimationController *)slideAnimationController {
    if (!_slideAnimationController) {
        _slideAnimationController = [SlideAnimationController new];
    }
    
    return _slideAnimationController;
}

#pragma mark - Navigation Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        if ([toVC isKindOfClass:[SearchViewController class]]) {
            [self.fadeAnimationController setFadeDirection:FadeDirectionIn];
            
            return self.fadeAnimationController;
        }
        else if ([toVC isKindOfClass:[ProgramsViewController class]]) {
            [self.slideAnimationController setSlideDirection:SlideDirectionLeft];
            
            return self.slideAnimationController;
        }
        else {
            [self.detailAnimationController setDetailDirection:DetailDirectionIn];
            
            return self.detailAnimationController;
        }
    }
    else {
        if ([fromVC isKindOfClass:[SearchViewController class]]) {
            [self.fadeAnimationController setFadeDirection:FadeDirectionOut];
            
            return self.fadeAnimationController;
        }
        else if ([fromVC isKindOfClass:[ProgramsViewController class]]) {
            [self.slideAnimationController setSlideDirection:SlideDirectionRight];
            
            return self.slideAnimationController;
        }
        else {
            [self.detailAnimationController setDetailDirection:DetailDirectionOut];
            
            return self.detailAnimationController;
        }
    }
    
    return nil;
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