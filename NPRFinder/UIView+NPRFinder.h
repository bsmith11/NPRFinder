//
//  UIView+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NPRFinder)

- (void)npr_setAlpha:(CGFloat)alpha
            duration:(NSTimeInterval)duration
            animated:(BOOL)animated
          completion:(void (^)(BOOL finished))completion;

@end
