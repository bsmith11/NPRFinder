//
//  SearchViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "SearchViewController.h"
#import "UIButton+NPRFinder.h"
#import "UITextField+NPRFinder.h"
#import "StationTableViewCell.h"
#import "UITableViewCell+NPRFinder.h"
#import "UITableView+NPRFinder.h"
#import "NetworkManager.h"
#import "Station.h"
#import "HomeViewController.h"
#import "StationViewController.h"
#import "ErrorManager.h"
#import "SwitchConstants.h"
#import "TransitionController.h"
#import "DetailAnimationController.h"

static NSString * const kSearchTextFieldPlaceholderText = @"Search for stations";

@interface SearchViewController ()

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic)  UITextField *searchTextField;

@property (copy, nonatomic) UIImage *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *stationTableView;

@end

@implementation SearchViewController

#pragma mark - View Lifecycle

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    
    if (self) {
        _backgroundImage = backgroundImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stations = [NSArray array];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setupBackgroundImageView];
    [self setupCloseButton];
    [self setupSearchTextField];
    [self setupStationTableView];
    
    [self.nprNavigationBar hideRightItemWithAnimation:NPRItemAnimationSlideHorizontally
                                             animated:NO
                                           completion:nil];
    [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationSlideHorizontally
                                            animated:NO
                                          completion:nil];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.nprNavigationBar showRightItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                 animated:YES
                                               completion:nil];
        [self.nprNavigationBar showLeftItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                animated:YES
                                              completion:nil];
        
        [self.backgroundImageView.layer removeAllAnimations];
        
        [self.searchTextField becomeFirstResponder];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.nprNavigationBar hideRightItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                 animated:YES
                                               completion:nil];
        [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationSlideHorizontally
                                                animated:YES
                                              completion:nil];
        
        [self.searchTextField resignFirstResponder];
    } completion:nil];
}

#pragma mark - Setup

- (void)setupBackgroundImageView {
    [self.backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundImageView setImage:self.backgroundImage];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton npr_setupWithStyle:NPRButtonStyleCloseButton
                                  target:self
                                  action:@selector(closeButtonPressed)];
    [self.nprNavigationBar setRightItem:self.closeButton];
}

- (void)setupSearchTextField {
    self.searchTextField = [UITextField new];
    [self.searchTextField npr_setupWithStyle:NPRTextFieldStyleSearch placeholderText:kSearchTextFieldPlaceholderText];
    [self.searchTextField addTarget:self
                             action:@selector(searchTextFieldValueChanged:)
                   forControlEvents:UIControlEventEditingChanged];
    [self.nprNavigationBar setLeftItem:self.searchTextField];
}

- (void)setupStationTableView {
    [self.stationTableView npr_setupWithStyle:NPRTableViewStyleStation
                                     delegate:self
                                   dataSource:self];
}

#pragma mark - Actions

- (void)closeButtonPressed {
    [self.searchTextField resignFirstResponder];
    
    if ([self.navigationController.viewControllers count] > 1) {
        HomeViewController *homeViewController = (HomeViewController *)self.navigationController.viewControllers[1];
        [homeViewController setShouldReloadTable:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextFieldValueChanged:(UITextField *)textField {
    NSString *text = textField.text;
    
    if ([text length] > 0) {
        [self searchForStationsWithText:text];
    }
    else {
        self.stations = [NSArray array];
        [self.stationTableView reloadData];
    }
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
    UIEdgeInsets contentInset = self.stationTableView.contentInset;
    contentInset.bottom = self.keyboardHeight;
    self.stationTableView.contentInset = contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    UIEdgeInsets contentInset = self.stationTableView.contentInset;
    contentInset.bottom = 0;
    self.stationTableView.contentInset = contentInset;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchTextField resignFirstResponder];
    
    Station *station = self.stations[indexPath.row];
    StationTableViewCell *cell = (StationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CGRect contentRect = [tableView convertRect:cell.frame fromView:cell.superview];
    
    [self.transitionController.detailAnimationController setContentRect:contentRect];
    [self.transitionController.detailAnimationController setTableView:tableView];
    
    StationViewController *stationViewController = [[StationViewController alloc] initWithStation:station backgroundImage:self.backgroundImage];
    [self.navigationController pushViewController:stationViewController animated:YES];
}

#pragma mark - Network Requests

- (void)searchForStationsWithText:(NSString *)text {
    if (kUseMockStationObjects) {
        [self handleSuccessfulStationSearchWithResponseObject:@[[Station mockStationJsonWithFrequency:@"89.4" signalStrength:@1],
                                                                      [Station mockStationJsonWithFrequency:@"94.6" signalStrength:@3],
                                                                      [Station mockStationJsonWithFrequency:@"98.9" signalStrength:@1],
                                                                      [Station mockStationJsonWithFrequency:@"105.6" signalStrength:@5]]];
    }
    else {
        [[NetworkManager sharedManager] searchForStationsWithText:text
                                                          success:^(NSURLSessionDataTask *task, id responseObject) {
#warning TODO: check if task has been cancelled
                                                              [self handleSuccessfulStationSearchWithResponseObject:responseObject];
                                                          }
                                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                              [self handleFailedStationSearchWithError:error];
                                                          }];
    }
}

- (void)handleSuccessfulStationSearchWithResponseObject:(id)responseObject {
    NSArray *jsonArray = (NSArray *)responseObject;
    NSError *error;
    
    self.stations = [MTLJSONAdapter modelsOfClass:Station.class fromJSONArray:jsonArray error:&error];
    [self.stationTableView reloadData];
}

- (void)handleFailedStationSearchWithError:(NSError *)error {
        [ErrorManager showAlertForNetworkError:error];
}

@end
