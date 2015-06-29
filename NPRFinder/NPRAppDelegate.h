//
//  NPRAppDelegate.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@class NPRTransitionController;

@interface NPRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NPRTransitionController *transitionController;

@end

