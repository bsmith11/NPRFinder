//
//  NPRStationViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationViewController.h"

#import "NPRStation+RZImport.h"
#import "NPRAudioManager.h"
#import "NPRStationView.h"
#import "NPRSearchViewController.h"

#import "UIView+NPRAutoLayout.h"

#import <RZDataBinding/RZDataBinding.h>
#import <MessageUI/MessageUI.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static NSString * const kNPRFacebookProfileURL = @"fb://profile/%@";
static NSString * const kNPRTwitterProfileURL = @"twitter://user?screen_name=%@";

typedef NS_ENUM(NSInteger, NPRAudioActionButtonState) {
    NPRAudioActionButtonStatePlaying,
    NPRAudioActionButtonStatePaused,
    NPRAudioActionButtonStateLoading
};

@interface NPRStationViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NPRStationViewModel *stationViewModel;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NPRStationView *stationView;

@property (assign, nonatomic) NPRAudioActionButtonState state;
@property (assign, nonatomic, getter=areOverflowButtonsShown) BOOL overflowButtonsShown;
@property (assign, nonatomic, getter=isFromSearch) BOOL fromSearch;

@end

@implementation NPRStationViewController

#pragma mark - Lifecycle

- (instancetype)initWithStationViewModel:(NPRStationViewModel *)stationViewModel
                         backgroundColor:(UIColor *)backgroundColor {
    self = [super init];

    if (self) {
        _stationViewModel = stationViewModel;
        _backgroundColor = backgroundColor;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupStationView];

    self.overflowButtonsShown = NO;

    BOOL shouldDisplayAudioActionButton = [self.stationViewModel.station preferredAudioStream];
    self.stationView.audioActionButton.hidden = !shouldDisplayAudioActionButton;

    if (shouldDisplayAudioActionButton) {
        self.state = NPRAudioActionButtonStatePaused;
        [[NPRAudioManager sharedManager] rz_addTarget:self
                                               action:@selector(audioManagerStateDidChange:)
                                     forKeyPathChange:RZDB_KP(NPRAudioManager, state)
                                      callImmediately:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];

        if ([fromViewController isKindOfClass:[NPRSearchViewController class]]) {
            self.stationView.backButton.transform = CGAffineTransformIdentity;
            self.stationView.backButton.alpha = 1.0f;
            [self.stationView.animatingViews removeObject:self.stationView.backButton];
        }

        if (![fromViewController isKindOfClass:[MFMailComposeViewController class]]) {
            [self.stationView showViews];
        }
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];

        if (![toViewController isKindOfClass:[MFMailComposeViewController class]]) {
            if (self.areOverflowButtonsShown) {
                [self closeButtonTapped];
            }

            [self.stationView hideViews];
        }
    } completion:nil];
}

- (void)setState:(NPRAudioActionButtonState)state {
    if (_state != state) {
        _state = state;
        
        switch (_state) {
            case NPRAudioActionButtonStatePlaying:
                self.stationView.audioActionButton.hidden = NO;
                [self.stationView.audioActivityIndicatorView stopAnimating];
                [self.stationView.audioActionButton setImage:[UIImage imageNamed:@"Pause Big Icon"] forState:UIControlStateNormal];
                break;
                
            case NPRAudioActionButtonStatePaused:
                self.stationView.audioActionButton.hidden = NO;
                [self.stationView.audioActivityIndicatorView stopAnimating];
                [self.stationView.audioActionButton setImage:[UIImage imageNamed:@"Play Big Icon"] forState:UIControlStateNormal];
                break;
                
            case NPRAudioActionButtonStateLoading:
                self.stationView.audioActionButton.hidden = YES;
                [self.stationView.audioActivityIndicatorView startAnimating];
                break;
        }
    }
}

#pragma mark - Setup

- (void)setupStationView {
    self.stationView = [[NPRStationView alloc] init];
    [self.view addSubview:self.stationView];

    [self.stationView npr_fillSuperview];

    self.stationView.backgroundColor = self.backgroundColor;

    [self.stationView.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.emailButton addTarget:self action:@selector(emailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.webButton addTarget:self action:@selector(webButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.facebookButton addTarget:self action:@selector(facebookButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.twitterButton addTarget:self action:@selector(twitterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.overflowButton addTarget:self action:@selector(overflowButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stationView.audioActionButton addTarget:self action:@selector(audioActionButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    self.stationView.frequencyLabel.text = self.stationViewModel.station.frequency;
    self.stationView.callLabel.text = self.stationViewModel.station.call;
    self.stationView.marketLocationLabel.text = self.stationViewModel.station.marketLocation;
}

#pragma mark - Actions

- (void)audioManagerStateDidChange:(NSDictionary *)change {
    NSNumber *stateObject = change[kRZDBChangeKeyNew];
    NPRAudioManagerState state = [stateObject integerValue];
    
    if ([[NPRAudioManager sharedManager].station isEqual:self.stationViewModel.station]) {
        switch (state) {
            case NPRAudioManagerStatePlaying:
                self.state = NPRAudioActionButtonStatePlaying;
                break;
                
            case NPRAudioManagerStatePaused:
            case NPRAudioManagerStateStopped:
                self.state = NPRAudioActionButtonStatePaused;
                break;
                
            case NPRAudioManagerStateLoading:
                self.state = NPRAudioActionButtonStateLoading;
                break;
        }
    }
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)emailButtonTapped {
    if ([MFMailComposeViewController canSendMail] && self.stationViewModel.station.email) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        NSArray *toRecipients = @[self.stationViewModel.station.email];
        [mailViewController setToRecipients:toRecipients];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mailViewController animated:YES completion:nil];
        });
    }
    else {
        DDLogInfo(@"No email address or unable to send mail");
    }
}

- (void)webButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:self.stationViewModel.station.homepageURL]) {
        [[UIApplication sharedApplication] openURL:self.stationViewModel.station.homepageURL];
    }
}

- (void)facebookButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:self.stationViewModel.station.facebookURL]) {
        [[UIApplication sharedApplication] openURL:self.stationViewModel.station.facebookURL];
    }
}

- (void)twitterButtonTapped {
    NSString *lastPathComponent = [self.stationViewModel.station.twitterURL lastPathComponent];
    NSString *twitterProfileString = [NSString stringWithFormat:kNPRTwitterProfileURL, lastPathComponent];
    NSURL *twitterProfileURL = [NSURL URLWithString:twitterProfileString];

    if ([[UIApplication sharedApplication] canOpenURL:twitterProfileURL]) {
        [[UIApplication sharedApplication] openURL:twitterProfileURL];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:self.stationViewModel.station.twitterURL]) {
        [[UIApplication sharedApplication] openURL:self.stationViewModel.station.twitterURL];
    }
}

- (void)overflowButtonTapped {
    self.overflowButtonsShown = YES;

    [self.stationView showOverflowButtons];
}

- (void)closeButtonTapped {
    self.overflowButtonsShown = NO;

    [self.stationView hideOverflowButtons];
}

- (void)audioActionButtonTapped {
        switch (self.state) {
            case NPRAudioActionButtonStatePlaying:
                [[NPRAudioManager sharedManager] pause];
                break;
                
            case NPRAudioActionButtonStatePaused:
                [[NPRAudioManager sharedManager] startPlayingStation:self.stationViewModel.station];
                break;
                
            case NPRAudioActionButtonStateLoading:
                //no-op
                break;
        }
}

#pragma mark - Mail View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        DDLogInfo(@"Failed MFMailComposeViewController with error: %@", error);
    }
    else {
        DDLogInfo(@"Result: %@", @(result));
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
