//
//  StationViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "StationViewController.h"
#import "UIImage+NPRFinder.h"
#import "UIButton+NPRFinder.h"
#import "UILabel+NPRFinder.h"
#import "UIScreen+NPRFinder.h"
#import "UITableView+NPRFinder.h"
#import "UITableViewCell+NPRFinder.h"
#import "UIView+NPRFinder.h"
#import "Station.h"
#import "StationUrl.h"
#import "Program.h"
#import "HomeViewController.h"
#import "TaglineTableViewCell.h"
#import "ProgramTableViewCell.h"
#import "NetworkManager.h"
#import "BaseNavigationController.h"
#import "StationDetailsTableViewCell.h"
#import "ProgramsViewController.h"
#import "SwitchConstants.h"
#import "UINavigationItem+NPRFinder.h"

static NSString * const kFacebookProfileUrl = @"fb://profile/%@";
static NSString * const kTwitterProfileUrl = @"twitter://user?id=%@";

static const CGFloat kDetailsTableViewFadeAnimationDuration = 0.4;

static const NSInteger kLinksIndexPath = 0;
static const NSInteger kProgramsIndexPath = 1;

@interface StationViewController ()

@property (strong, nonatomic) NSArray *programs;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIButton *closeButton;

@property (copy, nonatomic) Station *station;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoContainerViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewHeight;

@property (assign, nonatomic) BOOL shouldSetupGradientView;
@property (assign, nonatomic) BOOL shouldDisplayStationUrls;
@property (assign, nonatomic) BOOL didNavigateToPrograms;

@end

@implementation StationViewController

#pragma mark - View Lifecycle

- (instancetype)initWithStation:(Station *)station {
    return [self initWithStation:station backgroundImage:nil];
}

- (instancetype)initWithStation:(Station *)station backgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    
    if (self) {
        _station = station;
        _backgroundImage = backgroundImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundImageView];
    [self setupCloseButton];
    [self setupInfoContainerView];
    [self setupNameLabel];
    [self setupFrequencyLabel];
    [self setupLocationLabel];
    [self setupDetailsTableView];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.programs = [NSArray array];
    [self.gradientView setHidden:YES];
    self.shouldSetupGradientView = YES;
    self.shouldDisplayStationUrls = NO;
    self.didNavigateToPrograms = NO;
    
    [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationSlideHorizontally
                                            animated:NO
                                          completion:nil];
    [self hideDetailsTableViewAnimated:NO completion:nil];
    
    [self downloadStationPrograms];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.infoContainerView setHidden:NO];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.didNavigateToPrograms) {
            [self.nprNavigationBar showLeftItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                    animated:YES
                                                  completion:nil];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.didNavigateToPrograms) {
            [self showDetailsTableViewAnimated:YES completion:nil];
        }
        else {
            self.didNavigateToPrograms = NO;
            
            [self.nprNavigationBar showLeftItemWithAnimation:NPRItemAnimationFadeIn
                                                    animated:YES
                                                  completion:nil];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldSetupGradientView) {
        self.shouldSetupGradientView = NO;
        
        [self setupGradientView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NPRItemAnimation animation;
        if (!self.didNavigateToPrograms) {
            animation = NPRItemAnimationSlideHorizontally;
            [self.infoContainerView setHidden:YES];
            [self hideDetailsTableViewAnimated:YES completion:nil];
        }
        else {
            animation = NPRItemAnimationFadeOut;
        }

        [self.nprNavigationBar hideLeftItemWithAnimation:animation
                                                animated:YES
                                              completion:nil];
    } completion:nil];
}

#pragma mark - Setup

- (void)setupBackgroundImageView {
    [self.backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundImageView setImage:self.backgroundImage];
    [self.backgroundImageView setHidden:!self.backgroundImage];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton npr_setupWithStyle:NPRButtonStyleCloseButton
                                  target:self
                                  action:@selector(closeButtonPressed)];
    
    [self.nprNavigationBar setLeftItem:self.closeButton];
}

- (void)setupInfoContainerView {
    [self.infoContainerView setBackgroundColor:[UIColor clearColor]];
    CGFloat leftMargin = 20.0 + CGRectGetWidth(self.closeButton.frame);
    CGFloat width = [UIScreen npr_screenWidth] - (leftMargin * 2);
    [self.infoContainerViewWidth setConstant:width];    
}

- (void)setupFrequencyLabel {
    [self.frequencyLabel npr_setupWithStyle:NPRLabelStyleFocus];
    [self.frequencyLabel setText:self.station.frequency];
}

- (void)setupNameLabel {
    [self.nameLabel npr_setupWithStyle:NPRLabelStyleDetail];
    [self.nameLabel setText:self.station.call];
}

- (void)setupLocationLabel {
    [self.locationLabel npr_setupWithStyle:NPRLabelStyleDetail];
    [self.locationLabel setText:self.station.marketLocation];
}

- (void)setupDetailsTableView {
    [self.detailsTableView npr_setupWithStyle:NPRTableViewStyleStationDetails delegate:self dataSource:self];
    [self.detailsTableView setContentInset:UIEdgeInsetsMake(self.gradientViewHeight.constant * (3.0 / 4.0), 0, 0, 0)];
    [self.detailsTableView setAlwaysBounceVertical:NO];
}

- (void)setupGradientView {
    UIView *snapshotView = nil;
    if (self.backgroundImage) {
        snapshotView = [self.backgroundImageView snapshotViewAfterScreenUpdates:NO];
    }
    else {
        snapshotView = [self.baseNavigationController.backgroundImageView snapshotViewAfterScreenUpdates:NO];
    }
    
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

#pragma mark - Actions

- (void)closeButtonPressed {
    if ([self.navigationController.viewControllers count] > 1) {
        HomeViewController *homeViewController = (HomeViewController *)self.navigationController.viewControllers[1];
        [homeViewController setShouldReloadTable:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Requests

- (void)downloadStationPrograms {
    if (kUseMockProgramObjects) {
        id responseObject = @{@"item":@[[Program mockProgramJsonWithTitle:@"Program 0"],
                                        [Program mockProgramJsonWithTitle:@"Program 1"],
                                        [Program mockProgramJsonWithTitle:@"Program 2"],
                                        [Program mockProgramJsonWithTitle:@"Program 3"],
                                        [Program mockProgramJsonWithTitle:@"Program 4"],
                                        [Program mockProgramJsonWithTitle:@"Program 5"]]};
        
        [self handleSuccessfulGetProgramsRequestWithResponseObject:responseObject];
    }
    else {
        NetworkManager *networkManager = [NetworkManager sharedManager];
        
        [networkManager getProgramsForStation:self.station success:^(NSURLSessionDataTask *task, id responseObject) {
            [self handleSuccessfulGetProgramsRequestWithResponseObject:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self handleFailedGetProgramsRequestWithError:error];
        }];
    }
}

- (void)handleSuccessfulGetProgramsRequestWithResponseObject:(id)responseObject {
//    [self stopProgressIndicator];
    
    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
    NSArray *jsonArray = responseDictionary[@"item"];
    NSError *error;
    
    self.programs = [MTLJSONAdapter modelsOfClass:Program.class fromJSONArray:jsonArray error:&error];
    
//    NSSortDescriptor *sortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"signalStrength" ascending:NO];
//    self.stations = [self.stations sortedArrayUsingDescriptors:@[sortDescripter]];
    
    [self.detailsTableView reloadData];
}

- (void)handleFailedGetProgramsRequestWithError:(NSError *)error {
//    [self stopProgressIndicator];
    
//    [ErrorManager setupLabel:self.errorLabel networkError:error];
    
//    [self showErrorLabelAnimated:YES completion:nil];
//    [self setTitleLabelText:kLocationTitleLabelTextError animated:YES completion:nil];
}

#pragma mark - Station Url Table View Cell Delegate

- (void)facebookButtonPressed {
#warning TODO: Parse the facebook url
    StationUrl *stationUrl = self.station.urlsDictionary[@(StationUrlTypeFacebookUrl)];
    
    NSString *facebookProfileString = [NSString stringWithFormat:kFacebookProfileUrl, nil];
    NSURL *profileUrl = [NSURL URLWithString:facebookProfileString];
    
    if ([[UIApplication sharedApplication] canOpenURL:profileUrl]){
        [[UIApplication sharedApplication] openURL:profileUrl];
    }
    else {
        [[UIApplication sharedApplication] openURL:stationUrl.url];
    }
}

- (void)twitterButtonPressed {
#warning TODO: Parse the twitter url
    StationUrl *stationUrl = self.station.urlsDictionary[@(StationUrlTypeTwitterFeed)];
    
    NSString *twitterProfileString = [NSString stringWithFormat:kTwitterProfileUrl, nil];
    NSURL *profileUrl = [NSURL URLWithString:twitterProfileString];
    
    if ([[UIApplication sharedApplication] canOpenURL:profileUrl]){
        [[UIApplication sharedApplication] openURL:profileUrl];
    }
    else {
        [[UIApplication sharedApplication] openURL:stationUrl.url];
    }
}

- (void)homePageButtonPressed {
    StationUrl *stationUrl = self.station.urlsDictionary[@(StationUrlTypeOrganizationHomePage)];
    
    [[UIApplication sharedApplication] openURL:stationUrl.url];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    
    if ([self.programs count] > 0) {
        count++;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kLinksIndexPath) {
        return [StationUrlTableViewCell height];
    }
    else {
        return [StationDetailsTableViewCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kLinksIndexPath) {
        StationUrlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[StationUrlTableViewCell npr_reuseIdentifier] forIndexPath:indexPath];
        
        [cell setDelegate:self];
        [cell setupWithStation:self.station];
        
        return cell;
    }
    else {
        StationDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[StationDetailsTableViewCell npr_reuseIdentifier] forIndexPath:indexPath];
        if (indexPath.row == kProgramsIndexPath) {
            [cell setupWithText:@"Programs" count:[self.programs count] indexPath:indexPath];
        }
        else {
            [cell setupWithText:@"Programs" count:[self.programs count] indexPath:indexPath];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kProgramsIndexPath) {
        self.didNavigateToPrograms = YES;
    
        ProgramsViewController *programsViewController = [[ProgramsViewController alloc] initWithPrograms:self.programs];
    
        [self.navigationController pushViewController:programsViewController animated:YES];
    }
}

#pragma mark - Animations

- (void)hideDetailsTableViewAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.detailsTableView npr_setAlpha:0.0
                               duration:kDetailsTableViewFadeAnimationDuration
                               animated:animated
                             completion:completion];
}

- (void)showDetailsTableViewAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.detailsTableView npr_setAlpha:1.0
                               duration:kDetailsTableViewFadeAnimationDuration
                               animated:animated
                             completion:completion];
}

@end
