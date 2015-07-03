//
//  NPRHomeView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPREmptyListView.h"
#import "NPRActivityIndicatorView.h"

@interface NPRHomeView : UIView

- (void)showBrandLabelWithDelay:(CGFloat)delay;
- (void)hideBrandLabel;

- (void)showSearchButtonWithDelay:(CGFloat)delay;
- (void)hideSearchButton;

- (void)showEmptyListViewWithDelay:(CGFloat)delay;
- (void)hideEmptyListView;

@property (strong, nonatomic) UICollectionView *homeCollectionView;
@property (strong, nonatomic) UILabel *brandLabel;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) NPREmptyListView *emptyListView;
@property (strong, nonatomic) NPRActivityIndicatorView *activityIndicatorView;

@end
