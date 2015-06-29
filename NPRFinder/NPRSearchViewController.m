//
//  NPRSearchViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSearchViewController.h"

#import "NPRStation+RZImport.h"
#import "NPRErrorManager.h"
#import "NPRStationCell.h"
#import "NPRStationViewController.h"
#import "NPRSearchView.h"

#import "UIView+NPRAutoLayout.h"
#import "UIColor+NPRStyle.h"

#import <RZUtils/RZCommonUtils.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) NPRSearchView *searchView;

@property (assign, nonatomic) BOOL shouldAnimateBackgroundView;

@end

@implementation NPRSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchView];

    self.shouldAnimateBackgroundView = YES;
    
    self.stations = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.searchView showViews];

        if (self.shouldAnimateBackgroundView) {
            [self.searchView showBackgroundView];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.searchView.backgroundColor = [UIColor npr_blueColor];
        self.searchView.backgroundView.hidden = NO;
        self.searchView.searchCollectionView.hidden = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.shouldAnimateBackgroundView) {
            [self.searchView hideBackgroundView];
        }

        [self.searchView hideViews];
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.searchView.searchTextField becomeFirstResponder];
}

#pragma mark - Setup

- (void)setupSearchView {
    self.searchView = [[NPRSearchView alloc] init];
    [self.view addSubview:self.searchView];

    [self.searchView npr_fillSuperview];

    [self.searchView.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchView.searchCollectionView.delegate = self;
    self.searchView.searchCollectionView.dataSource = self;
}

#pragma mark - Actions

- (void)startActivityIndicator {
    [self.searchView.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.searchView.activityIndicatorView stopAnimating];
}

- (void)backButtonTapped {
    [self.searchView.searchTextField resignFirstResponder];

    self.shouldAnimateBackgroundView = YES;
    self.searchView.backgroundView.hidden = NO;
    self.searchView.backgroundColor = [UIColor npr_redColor];

    if (![self.searchView.animatingViews containsObject:self.searchView.backButton]) {
        [self.searchView.animatingViews insertObject:self.searchView.backButton atIndex:0];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextFieldValueChanged:(UITextField *)textField {
    NSString *text = textField.text;

    self.stations = [NSArray array];
    [self.searchView.searchCollectionView reloadData];

    if ([text length] > 0) {
        [self searchForStationsWithText:text];
    }
}

- (void)searchForStationsWithText:(NSString *)text {
    [self startActivityIndicator];

    [NPRStation getStationsWithSearchText:text completion:^(NSArray *stations, NSError *error) {
        [self stopActivityIndicator];

        if (error) {
            if (error.code == NSURLErrorCancelled) {
                DDLogInfo(@"Search request cancelled");
            }
            else {
                DDLogInfo(@"Failed to find stations with error: %@", error);
                self.stations = [NSArray array];
                [self.searchView.searchCollectionView reloadData];
            }
        }
        else {
            self.stations = stations;
            [self.searchView.searchCollectionView reloadData];
        }
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.stations count];
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier] forIndexPath:indexPath];
    NPRStation *station = self.stations[indexPath.item];
    
    [cell setupWithStation:station];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchView.searchTextField resignFirstResponder];

    NPRStation *station = self.stations[indexPath.row];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStation:station color:self.searchView.backgroundView.backgroundColor];
    stationViewController.isFromSearch = YES;

    self.npr_transitionController.slideAnimationController.collectionView = collectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = indexPath;
    
    [self.searchView.animatingViews removeObject:self.searchView.backButton];
    self.shouldAnimateBackgroundView = NO;
    self.searchView.backgroundView.hidden = YES;

    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self adjustTopBarContainerViewForContentOffset:scrollView.contentOffset];
}

- (void)adjustTopBarContainerViewForContentOffset:(CGPoint)contentOffset {
    CGFloat minValue = -CGRectGetHeight(self.searchView.topBarContainerView.frame) - self.searchView.searchCollectionView.contentInset.top;
    CGFloat maxValue = 20.0f;
    CGFloat adjustedValue = -(contentOffset.y + self.searchView.searchCollectionView.contentInset.top) + maxValue;
    adjustedValue = RZClampFloat(adjustedValue, minValue, maxValue);

    if (self.searchView.topBarContainerViewTop.constant != adjustedValue) {
        self.searchView.topBarContainerViewTop.constant = adjustedValue;
    }
}

@end
