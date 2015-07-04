//
//  NPRStationView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRActivityIndicatorView.h"
#import "NPRButton.h"

@interface NPRStationView : UIView

- (void)showViews;
- (void)hideViews;

- (void)showOverflowButtons;
- (void)hideOverflowButtons;

@property (strong, nonatomic) NPRButton *backButton;
@property (strong, nonatomic) UILabel *frequencyLabel;
@property (strong, nonatomic) UILabel *callLabel;
@property (strong, nonatomic) UIButton *audioActionButton;
@property (strong, nonatomic) NPRActivityIndicatorView *audioActivityIndicatorView;
@property (strong, nonatomic) UILabel *marketLocationLabel;
@property (strong, nonatomic) NPRButton *overflowButton;
@property (strong, nonatomic) NPRButton *closeButton;
@property (strong, nonatomic) NPRButton *twitterButton;
@property (strong, nonatomic) NPRButton *facebookButton;
@property (strong, nonatomic) NPRButton *webButton;
@property (strong, nonatomic) NPRButton *emailButton;

@property (strong, nonatomic) NSMutableArray *animatingViews;

@end
