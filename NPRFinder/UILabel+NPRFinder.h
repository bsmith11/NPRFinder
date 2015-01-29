//
//  UILabel+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRLabelStyle) {
    NPRLabelStyleTitle,
    NPRLabelStyleDetail,
    NPRLabelStyleFocus,
    NPRLabelStyleSplash,
    NPRLabelStyleError
};

@interface UILabel (NPRFinder)

- (void)npr_setupWithStyle:(NPRLabelStyle)style;
- (void)npr_setText:(NSString *)text animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)npr_hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)npr_showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

+ (CGFloat)npr_heightForText:(NSString *)text size:(CGSize)size style:(NPRLabelStyle)style;

@end
