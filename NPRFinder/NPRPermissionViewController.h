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

@interface NPRPermissionViewController : NPRBaseViewController

- (instancetype)initWithType:(NPRPermissionType)type;

@end
