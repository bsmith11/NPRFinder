//
//  UIButton+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRButtonStyle) {
    NPRButtonStyleCloseButton,
    NPRButtonStyleSearchButton,
    NPRButtonStyleRetryButton,
    NPRButtonStyleFacebookButton,
    NPRButtonStyleTwitterButton,
    NPRButtonStyleHomePageButton,
    NPRButtonStyleAcceptButton,
    NPRButtonStyleDenyButton,
    NPRButtonStyleBackButton,
    NPRButtonStyleForwardButton
};

@interface UIButton (NPRFinder)

- (void)npr_setupWithStyle:(NPRButtonStyle)style target:(id)target action:(SEL)action;

@end
