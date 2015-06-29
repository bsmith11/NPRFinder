//
//  NPRPermissionViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRPermissionViewController.h"

#import "NPRPermissionView.h"
#import "NPRLocationManager.h"
#import "UIView+NPRAutoLayout.h"

@interface NPRPermissionViewController () <NPRLocationManagerDelegate>

@property (strong, nonatomic) NPRPermissionView *permissionView;

@property (assign, nonatomic) NPRPermissionType type;

@end

@implementation NPRPermissionViewController

#pragma mark - Lifecycle

- (instancetype)initWithType:(NPRPermissionType)type {
    self = [super init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupPermissionView];

    [NPRLocationManager sharedManager].delegate = self;
}

#pragma mark - Setup

- (void)setupPermissionView {
    self.permissionView = [[NPRPermissionView alloc] init];
    [self.view addSubview:self.permissionView];

    [self.permissionView npr_fillSuperview];

    [self.permissionView.acceptButton addTarget:self action:@selector(acceptButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.permissionView.denyButton addTarget:self action:@selector(denyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)acceptButtonTapped {
    switch (self.type) {
        case NPRPermissionTypeLocationAlways:
            [[NPRLocationManager sharedManager] requestAlwaysAuthorization];
            break;

        case NPRPermissionTypeLocationWhenInUse:
            [[NPRLocationManager sharedManager] requestWhenInUseAuthorization];
            break;
    }
}

- (void)denyButtonTapped {
    [self dismiss];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Location Manager Delegate

- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:

            break;
            
        case kCLAuthorizationStatusDenied:

            break;
            
        case kCLAuthorizationStatusRestricted:
            
            break;
            
        default:
            break;
    }

    [self dismiss];
}

@end
