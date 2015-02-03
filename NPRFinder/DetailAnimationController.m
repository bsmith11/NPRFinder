//
//  DetailAnimationController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "DetailAnimationController.h"
#import "BaseViewController.h"

static const CGFloat kDetailAnimationDuration = 0.75;
//static const CGFloat kDetailAnimationSpringDampingValue = 1.0;
//static const CGFloat kDetailAnimationInitialSpringVelocityValue = 1.0;

@interface DetailAnimationController ()

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *bottomView;
@property (assign, nonatomic) CGFloat topTranslationDistance;
@property (assign, nonatomic) CGFloat contentTranslationDistance;
@property (assign, nonatomic) CGFloat bottomTranslationDistance;

@end

@implementation DetailAnimationController

#pragma mark - View Controller Animated Transitioning Delegate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    BaseViewController *toViewController = (BaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BaseViewController *fromViewController = (BaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    if (self.detailDirection == DetailDirectionIn) {
        self.topView = [self topSnapshotFromRect:self.contentRect
                                        rootView:fromViewController.view
                                       tableView:self.tableView];
        
        self.bottomView = [self bottomSnapshotFromRect:self.contentRect
                                              rootView:fromViewController.view
                                             tableView:self.tableView];
        
        self.contentView = [self contentSnapshotFromRect:self.contentRect
                                                rootView:fromViewController.view
                                               tableView:self.tableView];
        
        [self.tableView setAlpha:0.0];
    }
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:self.topView];
    [containerView addSubview:self.bottomView];
    [containerView addSubview:self.contentView];
    
    [toViewController.view setAlpha:0.0];
    
    if (self.detailDirection == DetailDirectionIn) {
        CGRect topRect = [fromViewController.view convertRect:self.topView.frame fromView:self.topView.superview];
        self.topTranslationDistance = -CGRectGetMaxY(topRect);
        
        CGRect bottomRect = [fromViewController.view convertRect:self.bottomView.frame fromView:self.bottomView.superview];
        self.bottomTranslationDistance = CGRectGetHeight(bottomRect);
        
        CGRect contentRect = [fromViewController.view convertRect:self.contentView.frame fromView:self.contentView.superview];
        self.contentTranslationDistance = -(CGRectGetMinY(contentRect) - 8.0);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
//         usingSpringWithDamping:kDetailAnimationSpringDampingValue
//          initialSpringVelocity:kDetailAnimationInitialSpringVelocityValue
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.detailDirection == DetailDirectionIn) {
                             self.topView.transform = CGAffineTransformMakeTranslation(0, self.topTranslationDistance);
                             self.bottomView.transform = CGAffineTransformMakeTranslation(0, self.bottomTranslationDistance);
                             self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentTranslationDistance);
                         }
                         else {
                             self.topView.transform = CGAffineTransformIdentity;
                             self.bottomView.transform = CGAffineTransformIdentity;
                             self.contentView.transform = CGAffineTransformIdentity;
                             
                             [fromViewController.view setAlpha:0.0];
                         }
                     }
                     completion:^(BOOL finished) {
                         if (![transitionContext transitionWasCancelled]) {
                             [containerView sendSubviewToBack:fromViewController.view];
                         }
                
                         [self.topView removeFromSuperview];
                         [self.contentView removeFromSuperview];
                         [self.bottomView removeFromSuperview];
                         [self.tableView setAlpha:1.0];
                         [toViewController.view setAlpha:1.0];
                                                  
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kDetailAnimationDuration;
}

- (UIView *)topSnapshotFromRect:(CGRect)rect rootView:(UIView *)rootView tableView:(UITableView *)tableView {
    CGRect topRect = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetMinY(rect));
    
    UIView *topView = [self.tableView resizableSnapshotViewFromRect:topRect
                                                 afterScreenUpdates:NO
                                                      withCapInsets:UIEdgeInsetsZero];
    
    CGRect topViewFrame = topView.frame;
    topViewFrame.origin.y = [rootView convertRect:topRect fromView:tableView].origin.y;
    [topView setFrame:topViewFrame];
    
    return topView;
}

- (UIView *)bottomSnapshotFromRect:(CGRect)rect rootView:(UIView *)rootView tableView:(UITableView *)tableView {
    CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(rect), CGRectGetWidth(tableView.frame), (tableView.contentOffset.y + CGRectGetHeight(tableView.frame) - CGRectGetMaxY(rect)));
    
    UIView *bottomView = [tableView resizableSnapshotViewFromRect:bottomRect
                                               afterScreenUpdates:NO
                                                    withCapInsets:UIEdgeInsetsZero];
    
    CGRect bottomViewFrame = bottomView.frame;
    bottomViewFrame.origin.y = [rootView convertRect:bottomRect fromView:tableView].origin.y;
    [bottomView setFrame:bottomViewFrame];
    
    return bottomView;
}

- (UIView *)contentSnapshotFromRect:(CGRect)rect rootView:(UIView *)rootView tableView:(UITableView *)tableView {
    CGRect contentRect = rect;
    
    UIView *contentView = [tableView resizableSnapshotViewFromRect:contentRect
                                                afterScreenUpdates:NO
                                                     withCapInsets:UIEdgeInsetsZero];
    
    CGRect contentViewFrame = contentView.frame;
    contentViewFrame.origin.y = [rootView convertRect:contentRect fromView:tableView].origin.y;
    [contentView setFrame:contentViewFrame];
    
    return contentView;
}

@end
