//
//  NPRStationViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationViewController.h"

#import "NPRStation+RZImport.h"
#import "NPRProgram+RZImport.h"
#import "NPRNetworkManager.h"
#import "NPRErrorManager.h"
#import "NPRSwitchConstants.h"
#import "UIImage+NPRStyle.h"
#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIScreen+NPRUtil.h"
#import "NPRAudioManager.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>
#import <RZUtils/UIView+RZAutoLayoutHelpers.h>
#import <RZDataBinding/RZDataBinding.h>
#import <MessageUI/MessageUI.h>

static NSString * const kNPRFacebookProfileURL = @"fb://profile/%@";
static NSString * const kNPRTwitterProfileURL = @"twitter://user?screen_name=%@";

static const CGFloat kNPRAnimationScaleValue = 0.1f;

typedef NS_ENUM(NSInteger, NPRAudioActionButtonState) {
    NPRAudioActionButtonStatePlaying,
    NPRAudioActionButtonStatePaused,
    NPRAudioActionButtonStateLoading
};

static const CGFloat kNPRStationMarketLocationBottomPadding = 20.0f;

@interface NPRStationViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *programs;
@property (strong, nonatomic) NPRStation *station;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NSArray *animatingViews;
@property (strong, nonatomic) NSMutableArray *overflowButtons;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *callLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *overflowButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *audioActionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *audioActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *marketLocationLabel;

@property (assign, nonatomic) NPRAudioActionButtonState state;
@property (assign, nonatomic, getter=areOverflowButtonsShown) BOOL overflowButtonsShown;
@property (assign, nonatomic, getter=isPresentingMail) BOOL presentingMail;

@end

@implementation NPRStationViewController

#pragma mark - Lifecycle

- (instancetype)initWithStation:(NPRStation *)station color:(UIColor *)color {
    self = [super init];
    
    if (self) {
        _station = station;
        _backgroundColor = color;
    }
    
    return self;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.backgroundColor;
    
    [self setupBackButton];
    [self setupFrequencyLabel];
    [self setupCallLabel];
    [self setupEmailButton];
    [self setupWebButton];
    [self setupFacebookButton];
    [self setupTwitterButton];
    [self setupOverflowButton];
    [self setupCloseButton];
    [self setupAudioActionButton];
    [self setupAudioActivityIndicatorView];
    [self setupMarketLocationLabel];
    
    if ([NPRAudioManager sharedManager].isAudioPlayerToolbarVisible) {
        [self audioPlayerToolbarHeightWillChange:44.0f];
    }
    
    self.programs = [NSArray array];
    self.overflowButtonsShown = NO;
    self.presentingMail = NO;
    
    [self downloadPrograms];
    
    self.animatingViews = @[self.backButton, self.frequencyLabel, self.callLabel, self.audioActionButton, self.marketLocationLabel, self.overflowButton];
    self.overflowButtons = [@[self.twitterButton, self.facebookButton, self.webButton, self.emailButton] mutableCopy];
    
    for (UIView *view in self.animatingViews) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }
    
    for (UIView *view in self.overflowButtons) {
        view.transform = CGAffineTransformMakeScale(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
        view.alpha = 0.0f;
    }
    
    self.closeButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.closeButton.alpha = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.isPresentingMail) {
            [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
                view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
                view.pop_spring.alpha = 1.0f;
            } completion:nil];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.presentingMail = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!self.isPresentingMail) {
            if (self.areOverflowButtonsShown) {
                [self overflowButtonTapped];
            }
            
            [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
                view.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
                view.pop_spring.alpha = 0.0f;
            } completion:nil];
        }
    } completion:nil];
}

- (void)setState:(NPRAudioActionButtonState)state {
    if (_state != state) {
        _state = state;
        
        switch (_state) {
            case NPRAudioActionButtonStatePlaying:
                self.audioActionButton.hidden = NO;
                [self.audioActivityIndicatorView stopAnimating];
                [self.audioActionButton setImage:[UIImage npr_pauseIcon] forState:UIControlStateNormal];
                break;
                
            case NPRAudioActionButtonStatePaused:
                self.audioActionButton.hidden = NO;
                [self.audioActivityIndicatorView stopAnimating];
                [self.audioActionButton setImage:[UIImage npr_playIcon] forState:UIControlStateNormal];
                break;
                
            case NPRAudioActionButtonStateLoading:
                self.audioActionButton.hidden = YES;
                [self.audioActivityIndicatorView startAnimating];
                break;
        }
    }
}

#pragma mark - Setup

- (void)setupBackButton {
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setImage:[UIImage npr_backIcon] forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor npr_foregroundColor];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFrequencyLabel {
    self.frequencyLabel.backgroundColor = [UIColor clearColor];
    self.frequencyLabel.textColor = [UIColor npr_foregroundColor];
    self.frequencyLabel.font = [UIFont npr_stationFrequencyFont];
    self.frequencyLabel.numberOfLines = 1;
    self.frequencyLabel.lineBreakMode = NSLineBreakByClipping;
    self.frequencyLabel.textAlignment = NSTextAlignmentCenter;
    self.frequencyLabel.text = self.station.frequency;
}

- (void)setupCallLabel {
    self.callLabel.backgroundColor = [UIColor clearColor];
    self.callLabel.textColor = [UIColor npr_foregroundColor];
    self.callLabel.font = [UIFont npr_stationCallFont];
    self.callLabel.numberOfLines = 1;
    self.callLabel.lineBreakMode = NSLineBreakByClipping;
    self.callLabel.textAlignment = NSTextAlignmentCenter;
    self.callLabel.text = self.station.call;
}

- (void)setupEmailButton {
    self.emailButton.backgroundColor = [UIColor clearColor];
    [self.emailButton setImage:[UIImage npr_emailIcon] forState:UIControlStateNormal];
    self.emailButton.tintColor = [UIColor npr_foregroundColor];
    [self.emailButton addTarget:self action:@selector(emailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWebButton {
    self.webButton.backgroundColor = [UIColor clearColor];
    [self.webButton setImage:[UIImage npr_webIcon] forState:UIControlStateNormal];
    self.webButton.tintColor = [UIColor npr_foregroundColor];
    [self.webButton addTarget:self action:@selector(webButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFacebookButton {
    self.facebookButton.backgroundColor = [UIColor clearColor];
    [self.facebookButton setImage:[UIImage npr_facebookIcon] forState:UIControlStateNormal];
    self.facebookButton.tintColor = [UIColor npr_foregroundColor];
    [self.facebookButton addTarget:self action:@selector(facebookButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTwitterButton {
    self.twitterButton.backgroundColor = [UIColor clearColor];
    [self.twitterButton setImage:[UIImage npr_twitterIcon] forState:UIControlStateNormal];
    self.twitterButton.tintColor = [UIColor npr_foregroundColor];
    [self.twitterButton addTarget:self action:@selector(twitterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupOverflowButton {
    self.overflowButton.backgroundColor = [UIColor clearColor];
//    self.overflowButton.adjustsImageWhenHighlighted = NO;
    [self.overflowButton setImage:[UIImage npr_overflowIcon] forState:UIControlStateNormal];
    self.overflowButton.tintColor = [UIColor npr_foregroundColor];
    [self.overflowButton addTarget:self action:@selector(overflowButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCloseButton {
    self.closeButton.backgroundColor = [UIColor clearColor];
//    self.closeButton.adjustsImageWhenHighlighted = NO;
    [self.closeButton setImage:[UIImage npr_closeIcon] forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor npr_foregroundColor];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupAudioActionButton {
    self.audioActionButton.backgroundColor = [UIColor clearColor];
    self.audioActionButton.tintColor = [UIColor npr_foregroundColor];
    [self.audioActionButton addTarget:self action:@selector(audioActionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.state = NPRAudioActionButtonStatePaused;
    [[NPRAudioManager sharedManager] rz_addTarget:self
                                           action:@selector(audioManagerStateDidChange:)
                                 forKeyPathChange:@"state"
                                  callImmediately:YES];
}

- (void)setupAudioActivityIndicatorView {
    self.audioActivityIndicatorView.hidesWhenStopped = YES;
    self.audioActivityIndicatorView.color = [UIColor npr_foregroundColor];
}

- (void)setupMarketLocationLabel {
    self.marketLocationLabel.backgroundColor = [UIColor clearColor];
    self.marketLocationLabel.textColor = [UIColor npr_foregroundColor];
    self.marketLocationLabel.font = [UIFont npr_stationMarketLocationFont];
    self.marketLocationLabel.numberOfLines = 1;
    self.marketLocationLabel.lineBreakMode = NSLineBreakByClipping;
    self.marketLocationLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *marketLocation = [NSString stringWithFormat:@"%@, %@", self.station.marketCity, self.station.marketState];
    self.marketLocationLabel.text = marketLocation;
}

#pragma mark - Actions

- (void)audioPlayerToolbarHeightWillChange:(CGFloat)height {
    [self.marketLocationLabel rz_pinnedBottomConstraint].pop_spring.constant = height + kNPRStationMarketLocationBottomPadding;
}

- (void)audioManagerStateDidChange:(NSDictionary *)change {
    NSNumber *stateObject = change[kRZDBChangeKeyNew];
    NPRAudioManagerState state = [stateObject integerValue];
    
    if ([[NPRAudioManager sharedManager].station isEqual:self.station]) {
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
    if ([MFMailComposeViewController canSendMail] && self.station.email) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        NSArray *toRecipients = @[self.station.email];
        [mailViewController setToRecipients:toRecipients];
        
        self.presentingMail = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mailViewController animated:YES completion:nil];
        });
    }
    else {
        NSLog(@"No email address or unable to send mail");
    }
}

- (void)webButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:self.station.homepageURL]) {
        [[UIApplication sharedApplication] openURL:self.station.homepageURL];
    }
}

- (void)facebookButtonTapped {
    if ([[UIApplication sharedApplication] canOpenURL:self.station.facebookURL]) {
        [[UIApplication sharedApplication] openURL:self.station.facebookURL];
    }
}

- (void)twitterButtonTapped {
        NSString *lastPathComponent = [self.station.twitterURL lastPathComponent];
        NSString *twitterProfileString = [NSString stringWithFormat:kNPRTwitterProfileURL, lastPathComponent];
        NSURL *twitterProfileURL = [NSURL URLWithString:twitterProfileString];
    
        if ([[UIApplication sharedApplication] canOpenURL:twitterProfileURL]) {
            [[UIApplication sharedApplication] openURL:twitterProfileURL];
        }
    if ([[UIApplication sharedApplication] canOpenURL:self.station.twitterURL]) {
        [[UIApplication sharedApplication] openURL:self.station.twitterURL];
    }
}

- (void)overflowButtonTapped {
    self.overflowButtonsShown = YES;
    
    self.overflowButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.overflowButton.pop_spring.alpha = 0.0f;
    
    [self.overflowButtons addObject:self.closeButton];
    
    [self.overflowButtons pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
        view.pop_spring.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.overflowButtons removeObject:self.closeButton];
    }];
}

- (void)closeButtonTapped {
    self.overflowButtonsShown = NO;
    
    self.closeButton.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
    self.closeButton.pop_spring.alpha = 0.0f;
    
    NSMutableArray *reverseOverflowButtons = [[[self.overflowButtons reverseObjectEnumerator] allObjects] mutableCopy];
    [reverseOverflowButtons addObject:self.overflowButton];
    [reverseOverflowButtons pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
        if (view == self.overflowButton) {
            self.overflowButton.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
            self.overflowButton.pop_spring.alpha = 1.0f;
        }
        else {
            view.pop_spring.pop_scaleXY = CGPointMake(kNPRAnimationScaleValue, kNPRAnimationScaleValue);
            view.pop_spring.alpha = 0.0f;
        }
    } completion:nil];
}

- (void)audioActionButtonTapped {
        switch (self.state) {
            case NPRAudioActionButtonStatePlaying:
                [[NPRAudioManager sharedManager] pause];
                break;
                
            case NPRAudioActionButtonStatePaused:
                [[NPRAudioManager sharedManager] startPlayingStation:self.station];
                break;
                
            case NPRAudioActionButtonStateLoading:
                //no-op
                break;
        }
}

- (void)downloadPrograms {
    [NPRProgram getProgramsForStation:self.station completion:^(NSArray *programs, NSError *error) {
        if (error) {
            [NPRErrorManager showAlertForNetworkError:error];
        }
        else {
            self.programs = programs;
        }
    }];
}

#pragma mark - Mail View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        NSLog(@"Failed MFMailComposeViewController with error: %@", error);
    }
    else {
        NSLog(@"Result: %@", @(result));
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
