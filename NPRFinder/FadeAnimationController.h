//
//  FadeAnimationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FadeDirection) {
    FadeDirectionIn,
    FadeDirectionOut
};

@interface FadeAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) FadeDirection fadeDirection;

@end