//
//  NPRPermissionViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRPermissionType) {
    NPRPermissionTypeNotifications,
    NPRPermissionTypeLocationAlways,
    NPRPermissionTypeLocationWhenInUse
};

@interface NPRPermissionViewController : UIViewController

- (instancetype)initWithType:(NPRPermissionType)type;

@end
