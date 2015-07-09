//
//  NPRSlideAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import ObjectiveC.runtime;

#import "NPRSlideAnimationController.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

typedef NSComparisonResult (^PositionComparison)(UIView *view1, UIView *view2);

static const CGFloat kNPRSlideAnimationDuration = 0.75f;
static const CGFloat kNPRSlideAnimationInterval = 0.03f;

static char kNPRSnapshotsAssocKey;
static char kNPRInitialFramesAssocKey;
static char kNPRBackgroundColorAssocKey;

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
        NSArray *cells = [self.collectionView.visibleCells sortedArrayUsingComparator:self.positionComparison];

//        NSMutableArray *snapshots = [NSMutableArray array];
//        NSMutableArray *initialFrames = [NSMutableArray array];
//        
//        for (UICollectionViewCell *cell in cells) {
//            UIView *snapshot = [cell.contentView snapshotViewAfterScreenUpdates:NO];
//            CGRect frame = [containerView convertRect:cell.contentView.frame fromView:cell];
//            snapshot.frame = frame;
//            [containerView addSubview:snapshot];
//            
//            [snapshots addObject:snapshot];
//            [initialFrames addObject:[NSValue valueWithCGRect:frame]];
//        }
//        
//        objc_setAssociatedObject(toViewController, &kNPRSnapshotsAssocKey, snapshots, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        objc_setAssociatedObject(toViewController, &kNPRInitialFramesAssocKey, initialFrames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];

        UIView *mainView = [fromViewController.view.subviews firstObject];
        UIColor *backgroundColor = mainView.backgroundColor;
        objc_setAssociatedObject(toViewController, &kNPRBackgroundColorAssocKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        mainView.backgroundColor = [UIColor clearColor];
        
//        self.collectionView.hidden = YES;

        void (^completion)(BOOL finished) = ^(BOOL finished) {
            [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        };

        if ([cells count] > 0) {
            [cells pop_sequenceWithInterval:kNPRSlideAnimationInterval animations:^(UIView *view, NSInteger index) {
                view.layer.pop_springBounciness = 0.0f;
                view.layer.pop_spring.pop_translationX = -CGRectGetWidth(view.bounds);
            } completion:completion];
        }
        else {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^ {
                completion(YES);
            });
        }

//        if ([snapshots count] > 0) {
//            [snapshots pop_sequenceWithInterval:kNPRSlideAnimationInterval animations:^(UIView *snapshot, NSInteger index) {
//                CGRect frame = snapshot.frame;
//                frame.origin.x = -CGRectGetWidth(frame);
//                snapshot.pop_spring.frame = frame;
//            } completion:completion];
//        }
//        else {
//            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
//            dispatch_after(time, dispatch_get_main_queue(), ^ {
//                completion(YES);
//            });
//        }
    }
    else {
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

        NSArray *cells = [self.collectionView.visibleCells sortedArrayUsingComparator:self.positionComparison];

//        NSMutableArray *snapshots = objc_getAssociatedObject(fromViewController, &kNPRSnapshotsAssocKey);
//        NSMutableArray *initialFrames = objc_getAssociatedObject(fromViewController, &kNPRInitialFramesAssocKey);
        UIColor *backgroundColor = objc_getAssociatedObject(fromViewController, &kNPRBackgroundColorAssocKey);

        void (^completion)(BOOL finished) = ^(BOOL finished) {
            UIView *mainView = [toViewController.view.subviews firstObject];
            mainView.backgroundColor = backgroundColor;

//            for (UIView *snapshot in snapshots) {
//                [snapshot removeFromSuperview];
//            }

            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        };

        if ([cells count] > 0) {
            [cells pop_sequenceWithInterval:kNPRSlideAnimationInterval animations:^(UIView *view, NSInteger index) {
                view.layer.pop_springBounciness = 0.0f;
                view.layer.pop_spring.pop_translationX = 0.0f;
            } completion:completion];
        }
        else {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^ {
                completion(YES);
            });
        }

//        if ([snapshots count] > 0) {
//            [snapshots pop_sequenceWithInterval:kNPRSlideAnimationInterval animations:^(UIView *snapshot, NSInteger index) {
//                snapshot.pop_springBounciness = kNPRSpringBounciness;
//                snapshot.pop_spring.frame = [initialFrames[index] CGRectValue];
//            } completion:completion];
//        }
//        else {
//            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [self transitionDuration:transitionContext] * NSEC_PER_SEC);
//            dispatch_after(time, dispatch_get_main_queue(), ^ {
//                completion(YES);
//            });
//        }
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRSlideAnimationDuration;
}

@end
