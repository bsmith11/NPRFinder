//
//  NPRPermissionViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"

typedef NS_ENUM(NSInteger, NPRPermissionType) {
    NPRPermissionTypeLocationAlways,
    NPRPermissionTypeLocationWhenInUse
};

@class NPRPermissionViewController;

@protocol NPRPermissionDelegate <NSObject>

- (void)didSelectAcceptForPermissionViewController:(NPRPermissionViewController *)permissionViewController;
- (void)didSelectDenyForPermissionViewController:(NPRPermissionViewController *)permissionViewController;

@end

@interface NPRPermissionViewController : NPRBaseViewController

- (instancetype)initWithType:(NPRPermissionType)type;

@property (weak, nonatomic) id <NPRPermissionDelegate> delegate;

@end
