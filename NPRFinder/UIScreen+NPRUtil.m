//
//  UIScreen+NPRUtil.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIScreen+NPRUtil.h"

static const CGFloat kNPRNavigationBarHeightPortrait = 44.0f;
static const CGFloat kNPRNavigationBarHeightLandscape = 32.0f;

@implementation UIScreen (NPRUtil)

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
        return kNPRNavigationBarHeightPortrait;
    }
    else {
        return kNPRNavigationBarHeightLandscape;
    }
}

+ (CGFloat)npr_statusBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}


@end
