//
//  NPRButton.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/3/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRButton.h"

@implementation NPRButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.slopInset, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    else {
        UIEdgeInsets inverseInsets = UIEdgeInsetsMake(-self.slopInset.top, -self.slopInset.left, -self.slopInset.bottom, -self.slopInset.right);
        
        return CGRectContainsPoint(UIEdgeInsetsInsetRect(self.bounds, inverseInsets), point);
    }
}

@end
