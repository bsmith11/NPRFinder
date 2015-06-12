//
//  NPRExpandAnimationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPRExpandAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) UIView *expandingView;

@property (assign, nonatomic, getter=isPositive) BOOL positive;

@end
