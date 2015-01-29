//
//  UIView+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIView+NPRFinder.h"

@implementation UIView (NPRFinder)

- (void)npr_setAlpha:(CGFloat)alpha duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {    
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            [self setAlpha:alpha];
        } completion:completion];
    }
    else {
        [self setAlpha:alpha];
        
        if (completion) {
            completion(YES);
        }
    }
}

@end
