//
//  NPRSplashViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"

@interface NPRSplashViewController : NPRBaseViewController

- (instancetype)initWithDismissBlock:(void (^)())dismissBlock;

@end
