//
//  UIFont+NPRStyle.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIFont+NPRStyle.h"

static NSString * const kNPRSplashFontName = @"GothamRounded-Bold";
static NSString * const kNPRSplashDiscoverFontName = @"GothamRounded-Bold";
static NSString * const kNPRPermissionRequestFontName = @"GothamRounded-Bold";
static NSString * const kNPRPermissionAcceptFontName = @"GothamRounded-Bold";
static NSString * const kNPRPermissionDenyFontName = @"GothamRounded-Bold";
static NSString * const kNPRAudioPlayerToolbarFontName = @"GothamRounded-Bold";
static NSString * const kNPRHomeStationFrequencyFontName = @"GothamRounded-Bold";
static NSString * const kNPRHomeStationEmptyListFontName = @"GothamRounded-Bold";
static NSString * const kNPRStationFrequencyFontName = @"GothamRounded-Bold";
static NSString * const kNPRStationCallFontName = @"GothamRounded-Bold";
static NSString * const kNPRStationMarketLocationFontName = @"GothamRounded-Bold";

static const CGFloat kNPRPermissionRequestFontSize = 22.0f;
static const CGFloat kNPRPermissionAcceptFontSize = 22.0f;
static const CGFloat kNPRPermissionDenyFontSize = 18.0f;
static const CGFloat kNPRAudioPlayerToolbarFontSize = 24.0f;
static const CGFloat kNPRHomeStationFrequencyFontSize = 64.0f;
static const CGFloat kNPRHomeStationEmptyListFontSize = 28.0f;
static const CGFloat kNPRStationFrequencyFontSize = 64.0f;
static const CGFloat kNPRStationCallFontSize = 32.0f;
static const CGFloat kNPRStationMarketLocationFontSize = 24.0f;

@implementation UIFont (NPRStyle)

+ (UIFont *)npr_splashFont {
    CGFloat size = (CGRectGetWidth([UIScreen mainScreen].bounds) / 3.0f) * 0.832f;
    return [UIFont fontWithName:kNPRSplashFontName size:size];
}

+ (UIFont *)npr_splashDiscoverFont {
    CGFloat size = (CGRectGetWidth([UIScreen mainScreen].bounds) / 3.0f) * 0.432f;
    return [UIFont fontWithName:kNPRSplashDiscoverFontName size:size];
}

+ (UIFont *)npr_permissionRequestFont {
    return [UIFont fontWithName:kNPRPermissionRequestFontName size:kNPRPermissionRequestFontSize];
}

+ (UIFont *)npr_permissionAcceptFont {
    return [UIFont fontWithName:kNPRPermissionAcceptFontName size:kNPRPermissionAcceptFontSize];
}

+ (UIFont *)npr_permissionDenyFont {
    return [UIFont fontWithName:kNPRPermissionDenyFontName size:kNPRPermissionDenyFontSize];
}

+ (UIFont *)npr_audioPlayerToolbarFont {
    return [UIFont fontWithName:kNPRAudioPlayerToolbarFontName size:kNPRAudioPlayerToolbarFontSize];
}

+ (UIFont *)npr_homeStationFrequencyFont {
    return [UIFont fontWithName:kNPRHomeStationFrequencyFontName size:kNPRHomeStationFrequencyFontSize];
}

+ (UIFont *)npr_homeEmptyListFont {
    return [UIFont fontWithName:kNPRHomeStationEmptyListFontName size:kNPRHomeStationEmptyListFontSize];
}

+ (UIFont *)npr_stationFrequencyFont {
    return [UIFont fontWithName:kNPRStationFrequencyFontName size:kNPRStationFrequencyFontSize];
}

+ (UIFont *)npr_stationCallFont {
    return [UIFont fontWithName:kNPRStationCallFontName size:kNPRStationCallFontSize];
}

+ (UIFont *)npr_stationMarketLocationFont {
    return [UIFont fontWithName:kNPRStationMarketLocationFontName size:kNPRStationMarketLocationFontSize];
}

@end
