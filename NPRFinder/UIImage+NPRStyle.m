//
//  UIImage+NPRStyle.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/12/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIImage+NPRStyle.h"

static NSString * const kSearchIconName = @"Search Icon";
static NSString * const kCloseIconName = @"Close Icon";
static NSString * const kSignalWeakIconName = @"Signal Weak Icon";
static NSString * const kSignalMediumIconName = @"Signal Medium Icon";
static NSString * const kSignalStrongIconName = @"Signal Strong Icon";
static NSString * const kSignalUnknownIconName = @"Signal Unknown Icon";
static NSString * const kFacebookIconName = @"Facebook Icon";
static NSString * const kTwitterIconName = @"Twitter Icon";
static NSString * const kBackIconName = @"Back Icon";
static NSString * const kFollowIconName = @"Follow Icon";
static NSString * const kPlayIconName = @"Play Icon";
static NSString * const kPauseIconName = @"Pause Icon";
static NSString * const kStopIconName = @"Stop Icon";
static NSString * const kMusicIconName = @"Music Icon";
static NSString * const kWebIconName = @"Web Icon";
static NSString * const kEmailIconName = @"Email Icon";
static NSString * const kOverflowIconName = @"Overflow Icon";

@implementation UIImage (NPRStyle)

+ (UIImage *)npr_searchIcon {
    return [[UIImage imageNamed:kSearchIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_closeIcon {
    return [[UIImage imageNamed:kCloseIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_signalWeakIcon {
    return [[UIImage imageNamed:kSignalWeakIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_signalMediumIcon {
    return [[UIImage imageNamed:kSignalMediumIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_signalStrongIcon {
    return [[UIImage imageNamed:kSignalStrongIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_signalUnknownIcon {
    return [[UIImage imageNamed:kSignalUnknownIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_imageForSignal:(NSNumber *)signal {
    UIImage *image;
    
    switch ([signal integerValue]) {
        case 0:
        case 1:
            image = [UIImage npr_signalWeakIcon];
            break;
            
        case 2:
        case 3:
            image = [UIImage npr_signalMediumIcon];
            break;
            
        case 4:
        case 5:
            image = [UIImage npr_signalStrongIcon];
            break;
            
        default:
            image = [UIImage npr_signalUnknownIcon];
            break;
    }
    
    return image;
}

+ (UIImage *)npr_facebookIcon {
    return [[UIImage imageNamed:kFacebookIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_twitterIcon {
    return [[UIImage imageNamed:kTwitterIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_backIcon {
    return [[UIImage imageNamed:kBackIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_followIcon {
    return [[UIImage imageNamed:kFollowIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_playIcon {
    return [[UIImage imageNamed:kPlayIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_pauseIcon {
    return [[UIImage imageNamed:kPauseIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_stopIcon {
    return [[UIImage imageNamed:kStopIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_musicIcon {
    return [[UIImage imageNamed:kMusicIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_webIcon {
    return [[UIImage imageNamed:kWebIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_emailIcon {
    return [[UIImage imageNamed:kEmailIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)npr_overflowIcon {
    return [[UIImage imageNamed:kOverflowIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
