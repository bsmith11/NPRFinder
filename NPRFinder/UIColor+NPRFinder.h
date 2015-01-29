//
//  UIColor+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NPRFinder)

+ (UIColor *)npr_colorWithHexValue:(NSString *)hexValue;
+ (UIColor *)npr_foregroundColor;
+ (UIColor *)npr_backgroundColor;
+ (UIColor *)npr_highlightColor;
+ (UIColor *)npr_redColor;
+ (UIColor *)npr_blackColor;
+ (UIColor *)npr_blueColor;
+ (UIColor *)npr_greyColor;
+ (UIColor *)npr_tealColor;

@end
