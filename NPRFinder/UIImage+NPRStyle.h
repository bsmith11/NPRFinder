//
//  UIImage+NPRStyle.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/12/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NPRStyle)

+ (UIImage *)npr_searchIcon;
+ (UIImage *)npr_closeIcon;
+ (UIImage *)npr_signalWeakIcon;
+ (UIImage *)npr_signalMediumIcon;
+ (UIImage *)npr_signalStrongIcon;
+ (UIImage *)npr_imageForSignal:(NSNumber *)signal;
+ (UIImage *)npr_facebookIcon;
+ (UIImage *)npr_twitterIcon;
+ (UIImage *)npr_backIcon;
+ (UIImage *)npr_followIcon;
+ (UIImage *)npr_playIcon;
+ (UIImage *)npr_pauseIcon;
+ (UIImage *)npr_stopIcon;
+ (UIImage *)npr_musicIcon;
+ (UIImage *)npr_webIcon;

@end
