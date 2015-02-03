//
//  HomeViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+NPRFinder.h"
#import "UILabel+NPRFinder.h"
#import "UIButton+NPRFinder.h"
#import "UITableViewCell+NPRFinder.h"
#import "NSString+NPRFinder.h"
#import "UIScreen+NPRFinder.h"
#import "UIColor+NPRFinder.h"
#import "UIView+NPRFinder.h"
#import "UIImage+ImageEffects.h"
#import "StationTableViewCell.h"
#import "UITableView+NPRFinder.h"
#import "Station.h"
#import "NetworkManager.h"
#import "ErrorManager.h"
#import "SearchViewController.h"
#import "FadeAnimationController.h"
#import "DetailAnimationController.h"
#import "StationViewController.h"
#import "SwitchConstants.h"
#import "BaseNavigationController.h"
#import "TransitionController.h"
#import "UINavigationItem+NPRFinder.h"
#import "AppDelegate.h"

static NSString * const kLocationTitleLabelTextPending = @"Finding your location...";
static NSString * const kLocationTitleLabelTextFound = @"Nearest NPR stations";
static NSString * const kLocationTitleLabelTextError = @"Failed to find stations";
static NSString * const kLocationTitleLabelTextErrorLocation = @"Failed to find location";

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) NSMutableArray *animatingCells;
@property (strong, nonatomic) SSPullToRefreshView *pullToRefreshView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *stationTableView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewHeight;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *errorLabel;

@property (assign, nonatomic) BOOL shouldSetupGradientView;
@property (assign, nonatomic) BOOL isPushingToSearch;

@end

@implementation HomeViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.stations = [NSArray array];
    self.animatingCells = [NSMutableArray array];
    self.shouldReloadTable = NO;
    self.isPushingToSearch = NO;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self setupBackgroundImageView];
    [self setupSearchButton];
    [self setupLocationTitleLabel];
    [self setupStationTableView];
    [self setupPullToRefresh];
    [self setupErrorLabel];
    [self setupAnimatingCells];
    
    [self.gradientView setHidden:YES];
    self.shouldSetupGradientView = YES;
    
    [self.errorLabel npr_hideAnimated:NO
                           completion:nil];
        
    [[LocationManager sharedManager] setDelegate:self];
    
    if (kUseLocationServices) {
        [self findCurrentLocation];
    }
    else {
        [self didUpdateLocation:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [self.transitionCoordinator animateAlongsideTransitionInView:window animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.nprNavigationBar showRightItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                 animated:NO
                                               completion:nil];
        [self.nprNavigationBar showLeftItemWithAnimation:NPRItemAnimationFadeIn
                                                animated:NO
                                              completion:nil];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            [self.nprNavigationBar finishHideRightItemWithAnimation:NPRItemAnimationSlideHorizontally];
            [self.nprNavigationBar finishHideLeftItemWithAnimation:NPRItemAnimationFadeIn];
        }
        else {
            [self.nprNavigationBar finishShowRightItemWithAnimation:NPRItemAnimationSlideHorizontally];
            [self.nprNavigationBar finishShowLeftItemWithAnimation:NPRItemAnimationFadeIn];
        }
    }];
    
    if (self.shouldReloadTable) {
        self.shouldReloadTable = NO;
        [self.stationTableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldSetupGradientView) {
        self.shouldSetupGradientView = NO;
        
        [self setupGradientView];
    }
    
    self.isPushingToSearch = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopTableViewCellAnimations];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [self.transitionCoordinator animateAlongsideTransitionInView:window animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.isPushingToSearch) {
            [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationFadeOut
                                                    animated:NO
                                                  completion:nil];
            [self.nprNavigationBar hideRightItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                     animated:NO
                                                   completion:nil];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.isPushingToSearch) {
            [self.nprNavigationBar finishHideLeftItemWithAnimation:NPRItemAnimationFadeOut];
            [self.nprNavigationBar finishHideRightItemWithAnimation:NPRItemAnimationSlideHorizontally];
        }
    }];
}

#pragma mark - Setup

- (void)setupBackgroundImageView {
    [self.backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];    
    [self.backgroundImageView setImage:[UIImage npr_backgroundImage]];
    [self.backgroundImageView setHidden:YES];
}

- (void)setupSearchButton {
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton npr_setupWithStyle:NPRButtonStyleSearchButton
                                   target:self
                                   action:@selector(searchButtonPressed)];
    
    [self.nprNavigationBar setRightItem:self.searchButton];
}

- (void)setupLocationTitleLabel {
    self.titleLabel = [UILabel new];
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleTitle];
    [self.titleLabel setText:kLocationTitleLabelTextPending];
    
    [self.nprNavigationBar setLeftItem:self.titleLabel];
}

- (void)setupStationTableView {
    [self.stationTableView npr_setupWithStyle:NPRTableViewStyleStation
                                     delegate:self
                                   dataSource:self];
    [self.stationTableView setContentInset:UIEdgeInsetsMake(self.gradientViewHeight.constant / 2.0, 0, 0, 0)];
}

- (void)setupPullToRefresh {
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.stationTableView
                                                                    delegate:self];
    
    SSPullToRefreshSimpleContentView *contentView = [SSPullToRefreshSimpleContentView new];
    [contentView.statusLabel setTextColor:[UIColor npr_foregroundColor]];
    [contentView.activityIndicatorView setColor:[UIColor npr_foregroundColor]];
    
    [self.pullToRefreshView setContentView:contentView];
}

- (void)setupGradientView {
    UIView *snapshotView = [self.baseNavigationController.backgroundImageView snapshotViewAfterScreenUpdates:NO];
    [self.gradientView addSubview:snapshotView];
    
    [self.gradientView setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect gradientLayerFrame = CGRectMake(0, 0, [UIScreen npr_screenWidth], self.gradientViewHeight.constant);
    [gradientLayer setFrame:gradientLayerFrame];
    
    [gradientLayer setColors:@[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                               (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor]]];
    
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(0.0, 1.0)];
    
    [self.gradientView.layer setMask:gradientLayer];
    
    [self.gradientView setHidden:YES];
}

- (void)setupErrorLabel {
    [self.errorLabel npr_setupWithStyle:NPRLabelStyleError];
    [self.errorLabel setDelegate:self];
}

- (void)setupAnimatingCells {
    [self.animatingCells removeAllObjects];
    
    NSInteger count = ceil(CGRectGetHeight(self.stationTableView.frame) / [StationTableViewCell estimatedHeight]);
    
    for (NSInteger row = 0; row < count; row++) {
        [self.animatingCells addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }
}

#pragma mark - Actions

- (void)findCurrentLocation {
    [self.errorLabel npr_hideAnimated:NO
                           completion:nil];
    
    [self.titleLabel npr_setText:kLocationTitleLabelTextPending animated:YES completion:nil];
    
    [self startProgressIndicator];
    [[LocationManager sharedManager] start];
}

- (void)searchButtonPressed {
    self.isPushingToSearch = YES;
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithBackgroundImage:[self screenshot]];
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)startProgressIndicator {
    
}

- (void)stopProgressIndicator {
    
}

#pragma mark - Network Requests

- (void)findStationsNearLocation:(CLLocation *)location {
    if (kUseMockStationObjects) {
        [self handleSuccessfulNearbyStationSearchWithResponseObject:@[[Station mockStationJsonWithFrequency:@"89.4" signalStrength:@1],
                                                                      [Station mockStationJsonWithFrequency:@"94.6" signalStrength:@3],
                                                                      [Station mockStationJsonWithFrequency:@"98.9" signalStrength:@1],
                                                                      [Station mockStationJsonWithFrequency:@"105.6" signalStrength:@5]]];
    }
    else {
        NSString *coordinates = [NSString npr_coordinatesFromLocation:location];
        
        [[NetworkManager sharedManager] searchForStationsWithText:coordinates
                                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                                              [self handleSuccessfulNearbyStationSearchWithResponseObject:responseObject];
                                                          }
                                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                              [self handleFailedNearbyStationSearchWithError:error];
                                                          }];
    }
}

- (void)handleSuccessfulNearbyStationSearchWithResponseObject:(id)responseObject {
    if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading) {
        [self.pullToRefreshView finishLoading];
    }
    
    [self.stationTableView setHidden:NO];
    
    [self stopProgressIndicator];
    
    [self.titleLabel npr_setText:kLocationTitleLabelTextFound animated:YES completion:nil];
    
    NSArray *jsonArray = (NSArray *)responseObject;
    NSError *error;
    
    self.stations = [MTLJSONAdapter modelsOfClass:Station.class fromJSONArray:jsonArray error:&error];
    
    NSSortDescriptor *sortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"signalStrength" ascending:NO];
    self.stations = [self.stations sortedArrayUsingDescriptors:@[sortDescripter]];
    
    [self.stationTableView reloadData];
}

- (void)handleFailedNearbyStationSearchWithError:(NSError *)error {
    if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading) {
        [self.pullToRefreshView finishLoading];
    }
    
    [self.stationTableView setHidden:YES];
    
    [self stopProgressIndicator];
    
    [ErrorManager setupLabel:self.errorLabel networkError:error];
    
    [self.errorLabel npr_showAnimated:YES completion:nil];
    [self.titleLabel npr_setText:kLocationTitleLabelTextError animated:YES completion:nil];
}

#pragma mark - Location Manager Delegate

- (void)didUpdateLocation:(CLLocation *)location {
    [self findStationsNearLocation:location];
}

- (void)didFailToFindLocationWithError:(NSError *)error {
    [self stopProgressIndicator];
    
    [self.stationTableView setHidden:YES];
    
    [ErrorManager setupLabel:self.errorLabel locationError:error];
    
    [self.errorLabel npr_showAnimated:YES completion:nil];
    [self.titleLabel npr_setText:kLocationTitleLabelTextErrorLocation animated:YES completion:nil];
}

- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self findCurrentLocation];
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            NSError *error = [NSError errorWithDomain:@"" code:kCLErrorDenied userInfo:nil];
            
            [self didFailToFindLocationWithError:error];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - TTT Attributed Label Delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Station *station = self.stations[indexPath.row];
    
    return [StationTableViewCell heightWithStation:station];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[StationTableViewCell npr_reuseIdentifier] forIndexPath:indexPath];
    
    Station *station = self.stations[indexPath.row];
    
    [cell setupWithStation:station];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.animatingCells containsObject:indexPath]) {
        [self.animatingCells removeObject:indexPath];
        
        StationTableViewCell *stationCell = (StationTableViewCell *)cell;
        
        Station *station = self.stations[indexPath.row];
        
        [stationCell hideWithStation:station delay:(indexPath.row / 5.0)];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    StationTableViewCell *stationCell = (StationTableViewCell *)cell;
    
    [stationCell stopAnimation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Station *station = self.stations[indexPath.row];
    StationTableViewCell *cell = (StationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
    CGRect contentRect = [tableView convertRect:cell.frame fromView:cell.superview];
    
    CGRect rect = [self.navigationController.view convertRect:cell.frame fromView:cell.superview];
    CGFloat maxPanDistance = (CGRectGetMinY(rect) - 8.0);
    
    [self.transitionController.detailAnimationController setContentRect:contentRect];
    [self.transitionController.detailAnimationController setTableView:tableView];
    
    StationViewController *stationViewController = [[StationViewController alloc] initWithStation:station];
    [stationViewController setMaxPanDistance:maxPanDistance];
    
    [self.navigationController pushViewController:stationViewController animated:YES];    
}

#pragma mark - SS Pull To Refresh Delegate

- (void)refreshStations {
    [self.pullToRefreshView startLoading];
    
    if (![[LocationManager sharedManager] isUpdatingLocation]) {
        [self findCurrentLocation];
    }
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refreshStations];
}

#pragma mark - Animations

- (void)stopTableViewCellAnimations {
    for (StationTableViewCell *cell in [self.stationTableView visibleCells]) {
        [cell stopAnimation];
    }
}

@end
