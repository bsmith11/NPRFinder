//
//  NPRSearchView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPREmptyListView.h"
#import "NPRActivityIndicatorView.h"

@interface NPRSearchView : UIView

- (void)adjustTopBarContainerViewForContentOffset:(CGPoint)contentOffset;

- (void)showViews;
- (void)hideViews;

- (void)showBackgroundView;
- (void)hideBackgroundView;

- (void)showEmptyListView;
- (void)hideEmptyListView;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UICollectionView *searchCollectionView;
@property (strong, nonatomic) UIView *topBarContainerView;
@property (strong, nonatomic) NSLayoutConstraint *topBarContainerViewTop;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NPREmptyListView *emptyListView;
@property (strong, nonatomic) NPRActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *animatingViews;

@end
