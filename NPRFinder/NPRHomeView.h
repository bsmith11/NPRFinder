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
#import "NPRButton.h"

@interface NPRHomeView : UIView

- (void)showSearchButtonAnimated:(BOOL)animated;
- (void)showSearchButtonAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)hideSearchButtonAnimated:(BOOL)animated;
- (void)hideSearchButtonAnimated:(BOOL)animated delay:(CGFloat)delay;

- (void)showEmptyListViewAnimated:(BOOL)animated;
- (void)showEmptyListViewAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)hideEmptyListViewAnimated:(BOOL)animated;
- (void)hideEmptyListViewAnimated:(BOOL)animated delay:(CGFloat)delay;

- (void)showActivityIndicatorViewAnimated:(BOOL)animated;
- (void)hideActivityIndicatorViewAnimated:(BOOL)animated;

- (void)showViews;
- (void)showViewsWithDelay:(CGFloat)delay;
- (void)hideViews;
- (void)hideViewsWithDelay:(CGFloat)delay;

@property (strong, nonatomic) UICollectionView *homeCollectionView;
@property (strong, nonatomic) NPRButton *locationButton;
@property (strong, nonatomic) NPRButton *searchButton;
@property (strong, nonatomic) NPREmptyListView *emptyListView;
@property (strong, nonatomic) NPRActivityIndicatorView *activityIndicatorView;

@end
