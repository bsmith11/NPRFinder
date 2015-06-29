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

static const CGFloat kNPRSlideAnimationDuration = 0.75f;
static const CGFloat kNPRAnimationInterval = 0.03f;
static const CGFloat kNPRSpringBounciness = 0.0f;

static char kNPRSnapshotsAssocKey;
static char kNPRInitialFramesAssocKey;
static char kNPRBackgroundColorAssocKey;

@implementation NPRSlideAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    if (self.isPositive) {
        NSMutableArray *cells = [self.collectionView.visibleCells mutableCopy];
        
        [cells sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
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
        }];
        
        NSMutableArray *snapshots = [NSMutableArray array];
        NSMutableArray *initialFrames = [NSMutableArray array];
        
        for (UICollectionViewCell *cell in cells) {
            UIView *snapshot = [cell.contentView snapshotViewAfterScreenUpdates:NO];
            CGRect frame = [containerView convertRect:cell.contentView.frame fromView:cell];
            snapshot.frame = frame;
            [containerView addSubview:snapshot];
            
            [snapshots addObject:snapshot];
            [initialFrames addObject:[NSValue valueWithCGRect:frame]];
        }
        
        objc_setAssociatedObject(toViewController, &kNPRSnapshotsAssocKey, snapshots, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(toViewController, &kNPRInitialFramesAssocKey, initialFrames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];

        UIView *mainView = [fromViewController.view.subviews firstObject];
        UIColor *backgroundColor = mainView.backgroundColor;
        objc_setAssociatedObject(toViewController, &kNPRBackgroundColorAssocKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        mainView.backgroundColor = [UIColor clearColor];
        
        self.collectionView.hidden = YES;
        
        [snapshots pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *snapshot, NSInteger index) {
            CGRect frame = snapshot.frame;
            frame.origin.x = -CGRectGetWidth(frame);
            snapshot.pop_spring.frame = frame;
        } completion:^(BOOL finished) {
            [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        NSMutableArray *snapshots = objc_getAssociatedObject(fromViewController, &kNPRSnapshotsAssocKey);
        NSMutableArray *initialFrames = objc_getAssociatedObject(fromViewController, &kNPRInitialFramesAssocKey);
        UIColor *backgroundColor = objc_getAssociatedObject(fromViewController, &kNPRBackgroundColorAssocKey);
        
        [snapshots pop_sequenceWithInterval:kNPRAnimationInterval animations:^(UIView *snapshot, NSInteger index) {
            snapshot.pop_springBounciness = kNPRSpringBounciness;
            snapshot.pop_spring.frame = [initialFrames[index] CGRectValue];
        } completion:^(BOOL finished) {
            UIView *mainView = [toViewController.view.subviews firstObject];
            mainView.backgroundColor = backgroundColor;
            
            for (UIView *snapshot in snapshots) {
                [snapshot removeFromSuperview];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNPRSlideAnimationDuration;
}

@end
