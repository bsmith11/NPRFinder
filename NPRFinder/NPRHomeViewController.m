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

#import "UIView+NPRAutoLayout.h"

@interface NPRHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NPRLocationManagerDelegate>

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) NPRHomeView *homeView;

@end

@implementation NPRHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHomeView];

    self.stations = [NSArray array];

    [NPRLocationManager sharedManager].delegate = self;

    if (kNPRUseLocationServices) {
        [self findCurrentLocation];
    }
    else {
        [self didUpdateLocation:nil];
    }
    
    [self.homeView.emptyListView hideAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        CGFloat delay = [context transitionDuration] / 3.0f;
        [self.homeView showBrandLabelWithDelay:delay];
        [self.homeView showSearchButtonWithDelay:delay];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.homeView.homeCollectionView.hidden = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.homeView hideBrandLabel];
        [self.homeView hideSearchButton];
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

    __weak typeof(self) weakSelf = self;
    self.homeView.emptyListView.actionBlock = ^{
        [weakSelf.homeView.emptyListView hideAnimated:NO completion:nil];
        [weakSelf findCurrentLocation];
    };
}

#pragma mark - Actions

- (void)startActivityIndicator {
    [self.homeView.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.homeView.activityIndicatorView stopAnimating];
}

- (void)searchButtonTapped {
//    if (self.activityIndicatorView.isAnimating) {
//        [self stopActivityIndicator];
//    }
//    else {
//        [self startActivityIndicator];
//    }

//    NPRPermissionViewController *vc = [[NPRPermissionViewController alloc] initWithType:NPRPermissionTypeLocationWhenInUse];
//    
//    [self.navigationController pushViewController:vc animated:NO];

    NPRSearchViewController *searchViewController = [[NPRSearchViewController alloc] init];
    
    self.npr_transitionController.slideAnimationController.collectionView = self.homeView.homeCollectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = nil;
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)findCurrentLocation {
    [self startActivityIndicator];
    [[NPRLocationManager sharedManager] start];
}

- (void)downloadStationsForLocation:(CLLocation *)location {
    [self startActivityIndicator];

    NSLog(@"Downloading stations for location: %@", location);
    
    [NPRStation getStationsNearLocation:location completion:^(NSArray *stations, NSError *error) {
        [self stopActivityIndicator];
        
        if (error) {
            [self.homeView.emptyListView showAnimated:NO completion:nil];
        }
        else {
            self.stations = stations;
            
            if ([self.stations count] > 0) {
                [self.homeView.emptyListView hideAnimated:NO completion:nil];
            }
            else {
                [self.homeView.emptyListView showAnimated:NO completion:nil];
            }
            
            [self.homeView.homeCollectionView reloadData];
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
    NPRStation *station = self.stations[indexPath.row];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStation:station color:self.homeView.backgroundColor];
    
    self.npr_transitionController.slideAnimationController.collectionView = self.homeView.homeCollectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = indexPath;
    
    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Location Manager Delegate

- (void)didUpdateLocation:(CLLocation *)location {
    [self downloadStationsForLocation:location];
}

- (void)didFailToFindLocationWithError:(NSError *)error {
    [self stopActivityIndicator];
}

- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (kNPRUseLocationServices) {
                [self findCurrentLocation];
            }
            break;
            
        case kCLAuthorizationStatusDenied: {
            NSError *error = [NSError errorWithDomain:@"npr_location_authorization_denied" code:kCLErrorDenied userInfo:nil];
            
            [self didFailToFindLocationWithError:error];
        }
            break;
            
        case kCLAuthorizationStatusRestricted: {
            NSError *error = [NSError errorWithDomain:@"npr_location_authorization_restricted" code:kCLErrorDenied userInfo:nil];
            
            [self didFailToFindLocationWithError:error];
        }
            break;
            
        default:
            break;
    }
}

@end
