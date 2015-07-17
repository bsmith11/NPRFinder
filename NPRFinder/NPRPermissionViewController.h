//
//  NPRPermissionViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"
#import "NPRSwitchConstants.h"

@class NPRPermissionViewController;

@protocol NPRPermissionDelegate <NSObject>

- (void)didSelectAcceptForPermissionViewController:(NPRPermissionViewController *)permissionViewController;
- (void)didSelectDenyForPermissionViewController:(NPRPermissionViewController *)permissionViewController;

@end

@interface NPRPermissionViewController : NPRBaseViewController

- (instancetype)initWithType:(NPRPermissionType)type;

@property (strong, nonatomic) id <UIViewControllerTransitionCoordinator> transitionCoordinator;

@property (weak, nonatomic) id <NPRPermissionDelegate> delegate;

@end
