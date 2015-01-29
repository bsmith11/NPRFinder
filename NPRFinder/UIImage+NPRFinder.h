//
//  UIImage+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NPRFinder)

+ (UIImage *)npr_searchIcon;
+ (UIImage *)npr_closeIcon;
+ (UIImage *)npr_signalWeakIcon;
+ (UIImage *)npr_signalMediumIcon;
+ (UIImage *)npr_signalStrongIcon;
+ (UIImage *)npr_imageForSignal:(NSNumber *)signal;
+ (UIImage *)npr_logoLine;
+ (UIImage *)npr_backgroundImage;
+ (UIImage *)npr_facebookIcon;
+ (UIImage *)npr_twitterIcon;
+ (UIImage *)npr_homeIcon;
+ (UIImage *)npr_backIcon;
+ (UIImage *)npr_forwardIcon;

@end
