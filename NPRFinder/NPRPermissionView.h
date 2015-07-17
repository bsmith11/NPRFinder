//
//  NPRPermissionView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface NPRPermissionView : UIView

@property (strong, nonatomic) UIImageView *locationServicesImageView;
@property (strong, nonatomic) UILabel *requestLabel;
@property (strong, nonatomic) UIButton *acceptButton;
@property (strong, nonatomic) UIButton *denyButton;

- (void)showViews;
- (void)hideViews;

@end
