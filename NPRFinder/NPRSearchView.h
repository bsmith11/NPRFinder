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
#import "NPRButton.h"

@interface NPRSearchView : UIView

- (void)adjustTopItemsForContentOffset:(CGPoint)contentOffset;

- (void)showViews;
- (void)hideViews;

- (void)showBackgroundView;
- (void)hideBackgroundView;

- (void)showEmptyListView;
- (void)hideEmptyListView;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UICollectionView *searchCollectionView;
@property (strong, nonatomic) NPRButton *backButton;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NPREmptyListView *emptyListView;
@property (strong, nonatomic) NPRActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *animatingViews;

@end
