//
//  NPRSplashViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"

@class NPRSplashViewController;

@protocol NPRSplashDelegate <NSObject>

- (void)didFinishAnimatingSplashViewController:(NPRSplashViewController *)splashViewController;

@end

@interface NPRSplashViewController : NPRBaseViewController

@property (weak, nonatomic) id <NPRSplashDelegate> delegate;

@end
