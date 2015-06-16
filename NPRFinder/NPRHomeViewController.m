//
//  NPRHomeViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeViewController.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "NPRStation+RZImport.h"
#import "NPRStationViewController.h"
#import "NPRSwitchConstants.h"
#import "NPRLocationManager.h"
#import "NPRErrorManager.h"
#import "NPRAudioManager.h"
#import "NPRHomeCollectionViewFlowLayout.h"
#import "UICollectionReusableView+NPRUtil.h"
#import "NPRStationCollectionViewCell.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

static NSString * const kNPRHomeNoResultsText = @"No stations found\n\n\n\nTry again?";

static const CGFloat kNPRHomeContentInsetAnimationDuration = 0.2f;

@interface NPRHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NPRLocationManagerDelegate, TTTAttributedLabelDelegate>

@property (strong, nonatomic) NSArray *stations;

@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *noResultsLabel;

@end

@implementation NPRHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.stations = [NSArray array];
    
    [self setupFeedCollectionView];
    [self setupNoResultsLabel];
    
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
    self.feedCollectionView.alwaysBounceVertical = YES;
    self.feedCollectionView.delegate = self;
    self.feedCollectionView.dataSource = self;
    [self.feedCollectionView registerNib:[NPRStationCollectionViewCell npr_nib]
              forCellWithReuseIdentifier:[NPRStationCollectionViewCell npr_reuseIdentifier]];
    
    NPRHomeCollectionViewFlowLayout *flowLayout = [[NPRHomeCollectionViewFlowLayout alloc] init];
    self.feedCollectionView.collectionViewLayout = flowLayout;
}

- (void)setupNoResultsLabel {
    self.noResultsLabel.backgroundColor = [UIColor clearColor];
    self.noResultsLabel.textColor = [UIColor npr_foregroundColor];
    self.noResultsLabel.font = [UIFont npr_homeNoResultsFont];
    self.noResultsLabel.numberOfLines = 0;
    self.noResultsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noResultsLabel.textAlignment = NSTextAlignmentCenter;
    self.noResultsLabel.text = kNPRHomeNoResultsText;
    self.noResultsLabel.longPressGestureRecognizer.enabled = NO;
    self.noResultsLabel.linkAttributes = @{NSForegroundColorAttributeName:self.noResultsLabel.textColor};
    UIColor *activeLinkColor = [self.noResultsLabel.textColor colorWithAlphaComponent:0.1f];
    self.noResultsLabel.activeLinkAttributes = @{(id)kCTForegroundColorAttributeName:activeLinkColor};
    self.noResultsLabel.delegate = self;
    
    NSURL *retryURL = [NSURL URLWithString:@"NPRFinder://retry"];
    NSRange range = [self.noResultsLabel.text rangeOfString:@"Try again?"];
    [self.noResultsLabel addLinkToURL:retryURL withRange:range];
    
    self.noResultsLabel.hidden = YES;
}

#pragma mark - Actions

- (void)audioPlayerToolbarHeightWillChange:(CGFloat)height {
    [super audioPlayerToolbarHeightWillChange:height];
    
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    contentInset.bottom = height;
    
    [UIView animateWithDuration:kNPRHomeContentInsetAnimationDuration animations:^{
        self.feedCollectionView.contentInset = contentInset;
    }];
}

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
//            NSMutableArray *indexPaths = [NSMutableArray array];
//            for (NSInteger i = 0; i < [stations count]; i++) {
//                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//            }
//            
//            [self.feedCollectionView performBatchUpdates:^{
//                [self.feedCollectionView insertItemsAtIndexPaths:indexPaths];
//            } completion:nil];
        }
    }];
}

- (void)startProgressIndicator {
    
}

- (void)stopProgressIndicator {
    
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.stations count];
    
    self.noResultsLabel.hidden = (count > 0);
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NPRStationCollectionViewCell npr_reuseIdentifier] forIndexPath:indexPath];
    NPRStation *station = self.stations[indexPath.item];
    
    [cell setupWithStation:station];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NPRStation *station = self.stations[indexPath.row];
    NPRStationCollectionViewCell *cell = (NPRStationCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NPRStationViewController *stationViewController = [[NPRStationViewController alloc] initWithStation:station color:cell.backgroundColor];
    
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

#pragma mark - TTT Attributed Label Delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    if ([[URL absoluteString] isEqualToString:@"NPRFinder://retry"]) {
        
    }
}

@end
