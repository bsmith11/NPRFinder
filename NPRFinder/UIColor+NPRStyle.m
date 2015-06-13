//
//  UIColor+NPRStyle.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIColor+NPRStyle.h"

#import <RZUtils/UIColor+RZExtensions.h>

static NSString * const kForegroundColorHexString = @"0BC78C";
static NSString * const kBackgroundColorHexString = @"000000";
static NSString * const kHighlightColorHexString = @"FFFFFF";
static NSString * const kRedColorHexString = @"EE411B";
static NSString * const kBlackColorHexString = @"000000";
static NSString * const kBlueColorHexString = @"005AB0";

@implementation UIColor (NPRStyle)

+ (UIColor *)npr_foregroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)npr_backgroundColor {
    return [UIColor rz_colorFromHexString:kBlackColorHexString];
}

+ (UIColor *)npr_highlightColor {
    return [UIColor rz_colorFromHexString:kHighlightColorHexString];
}

+ (UIColor *)npr_redColor {
    return [UIColor rz_colorFromHexString:kRedColorHexString];
}

+ (UIColor *)npr_blackColor {
    return [UIColor rz_colorFromHexString:kBlackColorHexString];
}

+ (UIColor *)npr_blueColor {
    return [UIColor rz_colorFromHexString:kBlueColorHexString];
}

@end
