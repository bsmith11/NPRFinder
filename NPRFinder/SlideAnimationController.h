//
//  SlideAnimationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlideDirection) {
    SlideDirectionUp,
    SlideDirectionRight,
    SlideDirectionDown,
    SlideDirectionLeft
};

@interface SlideAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) SlideDirection slideDirection;

@end
