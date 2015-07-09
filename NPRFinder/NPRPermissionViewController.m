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
#import "NPRUserDefaults.h"

@interface NPRPermissionViewController ()

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

    self.permissionView.backgroundView.hidden = YES;
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
    NPRLocationManagerAuthorizationCompletion completion = ^(CLAuthorizationStatus status) {
        [NPRUserDefaults setLocationServicesPermissionResponse:YES];

        if ([self.delegate respondsToSelector:@selector(didSelectAcceptForPermissionViewController:)]) {
            [self.delegate didSelectAcceptForPermissionViewController:self];
        }
    };

    switch (self.type) {
        case NPRPermissionTypeLocationAlways:
            [[NPRLocationManager sharedManager] requestAlwaysAuthorizationWithCompletion:completion];
            break;

        case NPRPermissionTypeLocationWhenInUse:
            [[NPRLocationManager sharedManager] requestWhenInUseAuthorizationWithCompletion:completion];
            break;
    }
}

- (void)denyButtonTapped {
    [NPRUserDefaults setLocationServicesPermissionResponse:NO];

    if ([self.delegate respondsToSelector:@selector(didSelectDenyForPermissionViewController:)]) {
        [self.delegate didSelectDenyForPermissionViewController:self];
    }
}

@end
