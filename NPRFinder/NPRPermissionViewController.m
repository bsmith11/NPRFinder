//
//  NPRPermissionViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRPermissionViewController.h"

static NSString * const kRequestLabelText = @"Can we use your location to find NPR stations near you?";

@interface NPRPermissionViewController ()

@property (weak, nonatomic) IBOutlet UIView *requestContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;

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
    
    [self setupRequestContainerView];
    [self setupTitleLabel];
    [self setupRequestLabel];
    [self setupButtonContainerView];
    [self setupAcceptButton];
    [self setupDenyButton];
}

#pragma mark - Setup

- (void)setupRequestContainerView {
    
}

- (void)setupTitleLabel {

}

- (void)setupRequestLabel {

}

- (void)setupButtonContainerView {
    
}

- (void)setupAcceptButton {

}

- (void)setupDenyButton {

}

#pragma mark - Actions

- (void)acceptButtonTapped {

}

- (void)denyButtonTapped {

}

@end
