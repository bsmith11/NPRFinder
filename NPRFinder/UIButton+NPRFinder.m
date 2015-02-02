//
//  UIButton+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIButton+NPRFinder.h"
#import "UIImage+NPRFinder.h"
#import "UIColor+NPRFinder.h"
#import "UIFont+NPRFinder.h"

static NSString * const kTryAgainButtonTitle = @"Try again?";
static NSString * const kAcceptButtonTitle = @"Yes";
static NSString * const kDenyButtonTitle = @"No";

@implementation UIButton (NPRFinder)

- (void)npr_setupWithStyle:(NPRButtonStyle)style target:(id)target action:(SEL)action {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitle:nil forState:UIControlStateNormal];
    [self setTintColor:[UIColor npr_foregroundColor]];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    switch (style) {
        case NPRButtonStyleCloseButton:
            [self setImage:[UIImage npr_closeIcon] forState:UIControlStateNormal];
            [self setFrame:CGRectMake(0, 0, 44.0, 44.0)];
            break;
            
        case NPRButtonStyleSearchButton:
            [self setImage:[UIImage npr_searchIcon] forState:UIControlStateNormal];
            [self setFrame:CGRectMake(0, 0, 44.0, 44.0)];
            break;
            
        case NPRButtonStyleRetryButton:
            [self setTitle:kTryAgainButtonTitle forState:UIControlStateNormal];
            [self setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont npr_titleFont]];
            [self setImage:nil forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleFacebookButton:
            [self setImage:[UIImage npr_facebookIcon] forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleTwitterButton:
            [self setImage:[UIImage npr_twitterIcon] forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleHomePageButton:
            [self setImage:[UIImage npr_homeIcon] forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleAcceptButton:
            [self setTitle:kAcceptButtonTitle forState:UIControlStateNormal];
            [self setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont npr_errorLinkFont]];
            [self setImage:nil forState:UIControlStateNormal];
            break;
        
        case NPRButtonStyleDenyButton:
            [self setTitle:kDenyButtonTitle forState:UIControlStateNormal];
            [self setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont npr_errorLinkFont]];
            [self setImage:nil forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleBackButton:
            [self setImage:[UIImage npr_backIcon] forState:UIControlStateNormal];
            [self setFrame:CGRectMake(0, 0, 44.0, 44.0)];
            break;
            
        case NPRButtonStyleForwardButton:
            [self setImage:[UIImage npr_forwardIcon] forState:UIControlStateNormal];
            break;
            
        case NPRButtonStyleFollowButton:
            [self setImage:[UIImage npr_followIcon] forState:UIControlStateNormal];
            [self setImage:[UIImage npr_followedIcon] forState:UIControlStateSelected];
            [self setFrame:CGRectMake(0, 0, 44.0, 44.0)];
            break;
            
        case NPRButtonStylePlayButton:
            [self setBackgroundImage:[UIImage npr_playIcon] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage npr_pauseIcon] forState:UIControlStateSelected];
            break;
            
        default:
            break;
    }
}

@end
