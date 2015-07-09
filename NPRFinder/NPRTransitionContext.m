//
//  NPRTransitionContext.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/5/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRTransitionContext.h"

@interface NPRTransitionContext ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSDictionary *viewControllers;

@end

@implementation NPRTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    self = [super init];

    if (self) {
        self.containerView = fromViewController.view.superview;
        self.viewControllers = @{UITransitionContextFromViewControllerKey:fromViewController,
                                 UITransitionContextToViewControllerKey:toViewController};
    }
    
    return self;
}

- (BOOL)isAnimated {
    return YES;
}

- (BOOL)isInteractive {
    return NO;
}

- (BOOL)transitionWasCancelled {
    return NO;
}

- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationCustom;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {

}

- (void)finishInteractiveTransition {

}

- (void)cancelInteractiveTransition {

}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completion) {
        self.completion(didComplete);
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.viewControllers[key];
}

- (UIView *)viewForKey:(NSString *)key {
    return nil;
}

- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    return CGRectZero;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    return CGRectZero;
}

@end
