//
//  UIFont+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIFont+NPRFinder.h"

static NSString * const kTitleFontName = @"HelveticaNeue-Thin";
static NSString * const kFocusFontName = @"HelveticaNeue-UltraLight";
static NSString * const kDetailFontName = @"HelveticaNeue-Thin";
static NSString * const kSplashFontName = @"HelveticaNeue-UltraLight";
static NSString * const kErrorLinkFontName = @"HelveticaNeue-Medium";
static NSString * const kErrorTitleFontName = @"HelveticaNeue-Thin";
static NSString * const kErrorMessageFontName = @"HelveticaNeue-Thin";

static const CGFloat kTitleFontSize = 24.0;
static const CGFloat kFocusFontSize = 64.0;
static const CGFloat kDetailFontSize = 24.0;
static const CGFloat kSplashFontSize = 70.0;
static const CGFloat kErrorLinkFontSize = 20.0;
static const CGFloat kErrorTitleFontSize = 24.0;
static const CGFloat kErrorMessageFontSize = 20.0;

@implementation UIFont (NPRFinder)

+ (UIFont *)npr_titleFont {
    return [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
}

+ (UIFont *)npr_focusFont {
    return [UIFont fontWithName:kFocusFontName size:kFocusFontSize];
}

+ (UIFont *)npr_detailFont {
    return [UIFont fontWithName:kDetailFontName size:kDetailFontSize];
}

+ (UIFont *)npr_splashFont {
    return [UIFont fontWithName:kSplashFontName size:kSplashFontSize];
}

+ (UIFont *)npr_errorLinkFont {
    return [UIFont fontWithName:kErrorLinkFontName size:kErrorLinkFontSize];
}

+ (UIFont *)npr_errorTitleFont {
    return [UIFont fontWithName:kErrorTitleFontName size:kErrorTitleFontSize];
}

+ (UIFont *)npr_errorMessageFont {
    return [UIFont fontWithName:kErrorMessageFontName size:kErrorMessageFontSize];
}

@end
