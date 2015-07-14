//
//  UIView+NPRAnimation.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface UIView (NPRAnimation)

- (void)npr_shrinkAnimated:(BOOL)animated;
- (void)npr_shrinkAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)npr_growAnimated:(BOOL)animated;
- (void)npr_growAnimated:(BOOL)animated delay:(CGFloat)delay;

@end
