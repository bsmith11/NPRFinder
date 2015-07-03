//
//  NPRHomeViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeViewController.h"

#import "NPRStation+RZImport.h"
#import "NPRStationViewController.h"
#import "NPRSwitchConstants.h"
#import "NPRLocationManager.h"
#import "NPRStationCell.h"
#import "NPRSearchViewController.h"
#import "NPRActivityIndicatorView.h"
#import "NPRPermissionViewController.h"
#import "NPRHomeView.h"
#import "NPRUserDefaults.h"

#import "UIView+NPRAutoLayout.h"

#import <RZDataBinding/RZDataBinding.h>

@interface NPRHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NPREmptyListViewDelegate>

@property (strong, nonatomic) NPRHomeViewModel *homeViewModel;
@property (strong, nonatomic) NPRHomeView *homeView;

@property (assign, nonatomic) BOOL emptyListViewShown;

@end

@implementation NPRHomeViewController

#pragma mark - Lifecycle

- (instancetype)initWithHomeViewModel:(NPRHomeViewModel *)homeViewModel {
    self = [super init];

    if (self) {
        _homeViewModel = homeViewModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHomeView];
    [self setupObservers];

    self.emptyListViewShown = NO;

    if ([NPRUserDefaults locationServicesPermissionResponse]) {
        if (kNPRUseLocationServices) {
            [self findCurrentLocation];
        }
        else {
            [self.homeViewModel searchForStationsNearLocation:nil];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        CGFloat delay = [context transitionDuration] / 3.0f;
        [self.homeView showBrandLabelWithDelay:delay];
        [self.homeView showSearchButtonWithDelay:delay];

        if (self.emptyListViewShown) {
            [self.homeView showEmptyListViewWithDelay:delay];
        }

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.homeView.homeCollectionView.hidden = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.homeView hideBrandLabel];
        [self.homeView hideSearchButton];

        if (self.emptyListViewShown) {
            [self.homeView hideEmptyListView];
        }
    } completion:nil];
}

#pragma mark - Setup

- (void)setupHomeView {
    self.homeView = [[NPRHomeView alloc] init];
    [self.view addSubview:self.homeView];

    [self.homeView npr_fillSuperview];

    [self.homeView.searchButton addTarget:self action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.homeView.homeCollectionView.dataSource = self;
    self.homeView.homeCollectionView.delegate = self;
    self.homeView.emptyListView.delegate = self;
}

- (void)setupObservers {
    [self.homeViewModel rz_addTarget:self
                              action:@selector(updateActivityIndicatorWithChange:)
                    forKeyPathChange:RZDB_KP(NPRHomeViewModel, searching)
                     callImmediately:YES];
    [self.homeViewModel rz_addTarget:self
                              action:@selector(searchErrorDidChange:)
                    forKeyPathChange:RZDB_KP(NPRHomeViewModel, error)
                     callImmediately:YES];
    [self.homeViewModel rz_addTarget:self
                              action:@selector(stationsDidChange:)
                    forKeyPathChange:RZDB_KP(NPRHomeViewModel, stations)
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
    [self.homeView.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.homeView.activityIndicatorView stopAnimating];
}

- (void)searchErrorDidChange:(NSDictionary *)change {
    NSError *error = change[kRZDBChangeKeyNew];

    if (error) {
        self.emptyListViewShown = YES;
        [self.homeView.emptyListView setupWithError:error];
        [self.homeView showEmptyListViewWithDelay:0.0f];
    }
    else {
        if (self.emptyListViewShown) {
            self.emptyListViewShown = NO;
            [self.homeView hideEmptyListView];
        }
    }
}

- (void)stationsDidChange:(NSDictionary *)change {
    [self.homeView.homeCollectionView reloadData];
}

- (void)searchButtonTapped {
    NPRSearchViewModel *searchViewModel = [[NPRSearchViewModel alloc] init];
    NPRSearchViewController *searchViewController = [[NPRSearchViewController alloc] initWithSearchViewModel:searchViewModel];
    
    self.npr_transitionController.slideAnimationController.collectionView = self.homeView.homeCollectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = nil;
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)findCurrentLocation {
    [self startActivityIndicator];

    [[NPRLocationManager sharedManager] requestCurrentLocationWithCompletion:^(CLLocation *location, NSError *error) {
        if (error) {
            [self stopActivityIndicator];
            [self searchErrorDidChange:@{kRZDBChangeKeyNew:error}];
        }
        else {
            [self.homeViewModel searchForStationsNearLocation:location];
        }
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.homeViewModel.stations count];
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NPRStationCell npr_reuseIdentifier] forIndexPath:indexPath];
    NPRStation *station = self.homeViewModel.stations[indexPath.item];
    
    [cell setupWithStation:station];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStation *station = self.homeViewModel.stations[indexPath.row];
    NPRStationViewModel *stationViewModel = [[NPRStationViewModel alloc] initWithStation:station];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStationViewModel:stationViewModel
                                                                                                 backgroundColor:self.homeView.backgroundColor];

    self.npr_transitionController.slideAnimationController.collectionView = self.homeView.homeCollectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = indexPath;
    
    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Empty List View Delegate

- (void)didSelectActionInEmptyListView:(NPREmptyListView *)emptyListView {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
