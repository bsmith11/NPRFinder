//
//  NPRBaseViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRTransitionController.h"
#import "NPRBaseNavigationController.h"

#import <UIKit/UIKit.h>

@interface NPRBaseViewController : UIViewController

- (NPRBaseNavigationController *)npr_baseNavigationController;
- (NPRTransitionController *)npr_transitionController;

@end
