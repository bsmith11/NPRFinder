//
//  UIColor+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIColor+NPRFinder.h"

static NSString * const kForegroundColorHexValue = @"0BC78C";
static NSString * const kBackgroundColorHexValue = @"000000";
static NSString * const kHighlightColorHexValue = @"FFFFFF";
static NSString * const kRedColorHexValue = @"FF3300";
static NSString * const kBlackColorHexValue = @"000000";
static NSString * const kBlueColorHexValue = @"3266CC";
static NSString * const kGreyColorHexValue = @"888784";
static NSString * const kTealColorHexValue = @"6496A4";

@implementation UIColor (NPRFinder)

+ (UIColor *)npr_colorWithHexValue:(NSString *)hexValue {
    if (hexValue) {
        NSString *cleanString = [hexValue stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if([cleanString length] == 3) {
            cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", [cleanString substringWithRange:NSMakeRange(0, 1)],
                                                                      [cleanString substringWithRange:NSMakeRange(0, 1)],
                                                                      [cleanString substringWithRange:NSMakeRange(1, 1)],
                                                                      [cleanString substringWithRange:NSMakeRange(1, 1)],
                                                                      [cleanString substringWithRange:NSMakeRange(2, 1)],
                                                                      [cleanString substringWithRange:NSMakeRange(2, 1)]];
        }
        
        if ([cleanString length] == 6) {
            cleanString = [cleanString stringByAppendingString:@"ff"];
        }
        
        unsigned int baseValue;
        [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
        
        float red = ((baseValue >> 24) & 0xFF) / 255.0f;
        float green = ((baseValue >> 16) & 0xFF) / 255.0f;
        float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
        float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
        
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    else {
        return nil;
    }
}

+ (UIColor *)npr_foregroundColor {
    return [UIColor npr_colorWithHexValue:kHighlightColorHexValue];
}

+ (UIColor *)npr_backgroundColor {
    return [UIColor npr_colorWithHexValue:kBlackColorHexValue];
}

+ (UIColor *)npr_highlightColor {
    return [UIColor npr_colorWithHexValue:kHighlightColorHexValue];
}

+ (UIColor *)npr_redColor {
    return [UIColor npr_colorWithHexValue:kRedColorHexValue];
}

+ (UIColor *)npr_blackColor {
    return [UIColor npr_colorWithHexValue:kBlackColorHexValue];
}

+ (UIColor *)npr_blueColor {
    return [UIColor npr_colorWithHexValue:kBlueColorHexValue];
}

+ (UIColor *)npr_greyColor {
    return [UIColor npr_colorWithHexValue:kGreyColorHexValue];
}

+ (UIColor *)npr_tealColor {
    return [UIColor npr_colorWithHexValue:kTealColorHexValue];
}

@end
