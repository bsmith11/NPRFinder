//
//  NPRSearchViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSearchViewController.h"
#import "NPRSearchView.h"

#import "NPRStation.h"
#import "NPRStationCell.h"
#import "NPRStationViewController.h"
#import "NPRStationViewModel.h"

#import "UIView+NPRAutoLayout.h"
#import "UIColor+NPRStyle.h"

#import <RZUtils/RZCommonUtils.h>
#import <RZDataBinding/RZDataBinding.h>

@interface NPRSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NPRSearchView *searchView;
@property (strong, nonatomic) NPRSearchViewModel *searchViewModel;

@property (assign, nonatomic) BOOL emptyListViewShown;

@end

@implementation NPRSearchViewController

#pragma mark - Lifecycle

- (instancetype)initWithSearchViewModel:(NPRSearchViewModel *)searchViewModel {
    self = [super init];

    if (self) {
        _searchViewModel = searchViewModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchView];
    [self setupObservers];

    [self.searchView.searchTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.searchView showViews];

        if (self.emptyListViewShown) {
            [self.searchView showEmptyListView];
        }
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.emptyListViewShown) {
            [self.searchView hideEmptyListView];
        }

        [self.searchView hideViews];
    } completion:nil];
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

- (void)setupObservers {
    [self.searchViewModel rz_addTarget:self
                                action:@selector(updateActivityIndicatorWithChange:)
                      forKeyPathChange:RZDB_KP(NPRSearchViewModel, searching)
                       callImmediately:YES];
    [self.searchViewModel rz_addTarget:self
                                action:@selector(searchErrorDidChange:)
                      forKeyPathChange:RZDB_KP(NPRSearchViewModel, error)
                       callImmediately:YES];
    [self.searchViewModel rz_addTarget:self
                                action:@selector(stationsDidChange:)
                      forKeyPathChange:RZDB_KP(NPRSearchViewModel, stations)
                       callImmediately:YES];
}

#pragma mark - Actions

- (void)updateActivityIndicatorWithChange:(NSDictionary *)change {
    BOOL searching = [change[kRZDBChangeKeyNew] boolValue];

    if (searching) {
        [self startActivityIndicator];
    }
    else {
        [self stopActivityIndicator];
    }
}

- (void)startActivityIndicator {
    [self.searchView.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.searchView.activityIndicatorView stopAnimating];
}

- (void)searchErrorDidChange:(NSDictionary *)change {
    NSError *error = change[kRZDBChangeKeyNew];

    if (error) {
        self.emptyListViewShown = YES;
        [self.searchView.emptyListView setupWithError:error];
        [self.searchView showEmptyListView];
    }
    else {
        if (self.emptyListViewShown) {
            self.emptyListViewShown = NO;
            [self.searchView hideEmptyListView];
        }
    }
}

- (void)stationsDidChange:(NSDictionary *)change {
    [self.searchView.searchCollectionView reloadData];
}

- (void)backButtonTapped {
    [self.searchView.searchTextField resignFirstResponder];

    if (![self.searchView.animatingViews containsObject:self.searchView.backButton]) {
        [self.searchView.animatingViews insertObject:self.searchView.backButton atIndex:0];
    }

    self.npr_transitionController.slideAnimationController.oldCollectionView = self.searchView.searchCollectionView;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextFieldValueChanged:(UITextField *)textField {
    NSString *text = textField.text;

    [self.searchViewModel searchForStationsWithText:text];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.searchViewModel.stations count];
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier] forIndexPath:indexPath];
    NPRStation *station = self.searchViewModel.stations[indexPath.item];
    
    [cell setupWithStation:station];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchView.searchTextField resignFirstResponder];

    NPRStation *station = self.searchViewModel.stations[indexPath.row];
    NPRStationViewModel *stationViewModel = [[NPRStationViewModel alloc] initWithStation:station];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStationViewModel:stationViewModel
                                                                                                 backgroundColor:self.searchView.backgroundColor];

    self.npr_transitionController.slideAnimationController.collectionView = collectionView;
    
    [self.searchView.animatingViews removeObject:self.searchView.backButton];

    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView adjustTopItemsForContentOffset:scrollView.contentOffset];
}

@end
