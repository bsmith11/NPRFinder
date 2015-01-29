//
//  UITextField+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRTextFieldStyle) {
    NPRTextFieldStyleSearch
};

@interface UITextField (NPRFinder)

- (void)npr_setupWithStyle:(NPRTextFieldStyle)style placeholderText:(NSString *)placeholderText;

@end
