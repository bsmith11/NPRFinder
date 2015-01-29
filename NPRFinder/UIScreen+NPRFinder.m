//
//  UIScreen+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIScreen+NPRFinder.h"

static const CGFloat kNavigationBarHeightPortrait = 44.0;
static const CGFloat kNavigationBarHeightLandscape = 32.0;

@implementation UIScreen (NPRFinder)

+ (CGFloat)npr_screenHeight {
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    else {
        return CGRectGetWidth([UIScreen mainScreen].bounds);
    }
}

+ (CGFloat)npr_screenWidth {
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return CGRectGetWidth([UIScreen mainScreen].bounds);
    }
    else {
        return CGRectGetHeight([UIScreen mainScreen].bounds);
    }
}

+ (CGFloat)npr_navigationBarHeight {
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return kNavigationBarHeightPortrait;
    }
    else {
        return kNavigationBarHeightLandscape;
    }
}

+ (CGFloat)npr_statusBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

@end
