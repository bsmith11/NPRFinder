//
//  NPRTransitionContext.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/5/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface NPRTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@property (copy, nonatomic) void (^completion)(BOOL finished);

@end
