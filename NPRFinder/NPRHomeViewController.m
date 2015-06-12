//
//  NPRHomeViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeViewController.h"

#import "UIScreen+NPRUtil.h"
#import "UIColor+NPRStyle.h"
#import "NPRStation+RZImport.h"
#import "NPRStationViewController.h"
#import "NPRSwitchConstants.h"
#import "NPRLocationManager.h"
#import "NPRErrorManager.h"

#import "UICollectionReusableView+NPRUtil.h"
#import "NPRStationCollectionViewCell.h"

static NSString * const kLocationTitleLabelTextPending = @"Finding your location...";
static NSString * const kLocationTitleLabelTextFound = @"Nearest NPR stations";
static NSString * const kLocationTitleLabelTextError = @"Failed to find stations";
static NSString * const kLocationTitleLabelTextErrorLocation = @"Failed to find location";

@interface NPRHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NPRLocationManagerDelegate>

@property (strong, nonatomic) NSArray *stations;

@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;

@end

@implementation NPRHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.stations = [NSArray array];
    
    [self setupFeedCollectionView];
    
    [NPRLocationManager sharedManager].delegate = self;
    
    if (kNPRUseLocationServices) {
        [self findCurrentLocation];
    }
    else {
        [self didUpdateLocation:nil];
    }
}

#pragma mark - Setup

- (void)setupFeedCollectionView {
    self.feedCollectionView.backgroundColor = [UIColor npr_redColor];
    self.feedCollectionView.showsVerticalScrollIndicator = NO;
    self.feedCollectionView.delegate = self;
    self.feedCollectionView.dataSource = self;
    [self.feedCollectionView registerNib:[NPRStationCollectionViewCell npr_nib]
              forCellWithReuseIdentifier:[NPRStationCollectionViewCell npr_reuseIdentifier]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.itemSize = CGSizeMake([UIScreen npr_screenWidth], 150.0f);
    self.feedCollectionView.collectionViewLayout = flowLayout;
}

#pragma mark - Actions

- (void)findCurrentLocation {
    [self startProgressIndicator];
    [[NPRLocationManager sharedManager] start];
}

- (void)downloadStationsForLocation:(CLLocation *)location {
    [NPRStation getStationsNearLocation:location completion:^(NSArray *stations, NSError *error) {
        if (error) {
            [NPRErrorManager showAlertForNetworkError:error];
        }
        else {
            self.stations = stations;
            [self.feedCollectionView reloadData];
        }
    }];
}

- (void)startProgressIndicator {
    
}

- (void)stopProgressIndicator {
    
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.stations count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NPRStationCollectionViewCell npr_reuseIdentifier] forIndexPath:indexPath];
    
    [cell setupWithStation:nil];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStation *station = self.stations[indexPath.row];
    NPRStationCollectionViewCell *cell = (NPRStationCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStation:station color:cell.backgroundColor];
    
//    self.npr_transitionController.expandAnimationController.expandingView = cell;
    self.npr_transitionController.slideAnimationController.collectionView = collectionView;
    self.npr_transitionController.slideAnimationController.selectedIndexPath = indexPath;
    
    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Location Manager Delegate

- (void)didUpdateLocation:(CLLocation *)location {
    [self downloadStationsForLocation:location];
}

- (void)didFailToFindLocationWithError:(NSError *)error {
    [self stopProgressIndicator];
}

- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self findCurrentLocation];
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
