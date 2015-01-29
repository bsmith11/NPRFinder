//
//  SlideAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "SlideAnimationController.h"
#import "UIScreen+NPRFinder.h"

static const CGFloat kSlideAnimationDuration = 0.75;
static const CGFloat kSlideAnimationSpringDampingValue = 1.0;
static const CGFloat kSlideAnimationInitialSpringVelocityValue = 1.0;

@implementation SlideAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    CGRect initialFromFrame;
    CGRect endFromFrame;
    
    CGRect initialToFrame;
    CGRect endToFrame;
    
    CGFloat horizontalSlideDistance = [UIScreen npr_screenWidth];
    CGFloat verticalSlideDistance = [UIScreen npr_screenHeight];
    
    switch (self.slideDirection) {
        case SlideDirectionUp:
            initialFromFrame = fromViewController.view.frame;
            
            endFromFrame = initialFromFrame;
            endFromFrame.origin.y -= verticalSlideDistance;
            
            initialToFrame = toViewController.view.frame;
            initialToFrame.origin.y += verticalSlideDistance;
            
            endToFrame = toViewController.view.frame;
            break;
            
        case SlideDirectionRight:
            initialFromFrame = fromViewController.view.frame;
            
            endFromFrame = initialFromFrame;
            endFromFrame.origin.x += horizontalSlideDistance;
            
            initialToFrame = toViewController.view.frame;
            initialToFrame.origin.x -= horizontalSlideDistance;
            
            endToFrame = toViewController.view.frame;
            break;
            
        case SlideDirectionDown:
            initialFromFrame = fromViewController.view.frame;
            
            endFromFrame = initialFromFrame;
            endFromFrame.origin.y += verticalSlideDistance;
            
            initialToFrame = toViewController.view.frame;
            initialToFrame.origin.y -= verticalSlideDistance;
            
            endToFrame = toViewController.view.frame;
            break;
            
        case SlideDirectionLeft:
            initialFromFrame = fromViewController.view.frame;
            
            endFromFrame = initialFromFrame;
            endFromFrame.origin.x -= horizontalSlideDistance;
            
            initialToFrame = toViewController.view.frame;
            initialToFrame.origin.x += horizontalSlideDistance;
            
            endToFrame = toViewController.view.frame;
            break;
            
        default:
            break;
    }
    
    [fromViewController.view setFrame:initialFromFrame];
    [toViewController.view setFrame:initialToFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:kSlideAnimationSpringDampingValue
          initialSpringVelocity:kSlideAnimationInitialSpringVelocityValue
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [fromViewController.view setFrame:endFromFrame];
                         [toViewController.view setFrame:endToFrame];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kSlideAnimationDuration;
}

@end
