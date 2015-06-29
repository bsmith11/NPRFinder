//
//  NPRStationView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRActivityIndicatorView.h"

@interface NPRStationView : UIView

- (void)showViews;
- (void)hideViews;

- (void)showOverflowButtons;
- (void)hideOverflowButtons;

@property (strong, nonatomic) UIView *topBarContainerView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *frequencyLabel;
@property (strong, nonatomic) UILabel *callLabel;
@property (strong, nonatomic) UIButton *audioActionButton;
@property (strong, nonatomic) NPRActivityIndicatorView *audioActivityIndicatorView;
@property (strong, nonatomic) UILabel *marketLocationLabel;
@property (strong, nonatomic) UIButton *overflowButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *twitterButton;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIButton *webButton;
@property (strong, nonatomic) UIButton *emailButton;

@property (strong, nonatomic) NSMutableArray *animatingViews;

@end
