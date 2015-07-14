//
//  NPRSlideAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import ObjectiveC.runtime;

#import "NPRSlideAnimationController.h"

#import "NPRAnimationConstants.h"
#import "UIScreen+NPRUtil.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

static const CGFloat kNPRSlideAnimationDuration = 0.5f;

static const char kNPRSlideAnimationCollectoinView;

typedef NSComparisonResult (^PositionComparison)(UIView *view1, UIView *view2);

@interface NPRSlideAnimationController ()

@property (copy, nonatomic) PositionComparison positionComparison;

@end

@implementation NPRSlideAnimationController

- (PositionComparison)positionComparison {
    if (!_positionComparison) {
        PositionComparison positionComparison = ^NSComparisonResult(UIView *view1, UIView *view2) {
            CGFloat minY1 = CGRectGetMinY(view1.frame);
            CGFloat minY2 = CGRectGetMinY(view2.frame);
            if (minY1 > minY2) {
                return NSOrderedDescending;
            }
            else if (minY1 < minY2) {
                return NSOrderedAscending;
            }
            else {
                return NSOrderedSame;
            }
        };

        _positionComparison = positionComparison;
    }

    return _positionComparison;
}

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;

    if (self.isPositive) {
        objc_setAssociatedObject(toViewController, &kNPRSlideAnimationCollectoinView, self.collectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        self.collectionView = objc_getAssociatedObject(fromViewController, &kNPRSlideAnimationCollectoinView);
    }

    NSArray *cells = [self.collectionView.visibleCells sortedArrayUsingComparator:self.positionComparison];
    CGFloat modifier = self.isPositive ? -1.0f : 1.0f;

    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

    [cells pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
        view.pop_springBounciness = 0.0f;
        CGRect frame = view.frame;
        frame.origin.x += modifier * CGRectGetWidth(view.frame);
        view.pop_spring.frame = frame;
    } completion:nil];

    if (self.oldCollectionView) {
        NSArray *oldCells = [self.oldCollectionView.visibleCells sortedArrayUsingComparator:self.positionComparison];
        [oldCells pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *view, NSInteger index) {
            view.pop_springBounciness = 0.0f;
            CGRect frame = view.frame;
            frame.origin.x = [UIScreen npr_screenWidth];
            view.pop_spring.frame = frame;
        } completion:nil];
    }

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^ {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRSlideAnimationDuration;
}

@end
