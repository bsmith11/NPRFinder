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

static NSString * const kFacebookProfileUrl = @"fb://profile/%@";
static NSString * const kTwitterProfileUrl = @"twitter://user?id=%@";

static const CGFloat kNPRStationMarketLocationBottomPadding = 10.0f;

@interface NPRStationViewController ()

@property (strong, nonatomic) NSArray *programs;
@property (strong, nonatomic) NPRStation *station;
@property (strong, nonatomic) NSArray *animatingViews;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *callLabel;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UILabel *marketLocationLabel;

@end

@implementation NPRStationViewController

#pragma mark - Lifecycle

- (instancetype)initWithStation:(NPRStation *)station color:(UIColor *)color {
    self = [super init];
    
    if (self) {
        _station = station;
        
        self.view.backgroundColor = color;
    }
    
    return self;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    [self setupFrequencyLabel];
    [self setupCallLabel];
    [self setupWebButton];
    [self setupFacebookButton];
    [self setupTwitterButton];
    [self setupMarketLocationLabel];
    
    self.programs = [NSArray array];
    
    [self downloadPrograms];
    
    self.animatingViews = @[self.backButton, self.frequencyLabel, self.callLabel, self.webButton, self.facebookButton, self.twitterButton, self.marketLocationLabel];
    
    for (UIView *view in self.animatingViews) {
        view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        view.alpha = 0.0f;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
            view.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
            view.pop_spring.alpha = 1.0f;
        } completion:nil];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.animatingViews pop_sequenceWithInterval:0.05f animations:^(UIView *view, NSInteger index) {
            view.pop_spring.pop_scaleXY = CGPointMake(0.01f, 0.01f);
            view.pop_spring.alpha = 0.0f;
        } completion:nil];
    } completion:nil];
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

- (void)setupMarketLocationLabel {
    self.marketLocationLabel.backgroundColor = [UIColor clearColor];
    self.marketLocationLabel.textColor = [UIColor npr_foregroundColor];
    self.marketLocationLabel.font = [UIFont npr_stationMarketLocationFont];
    self.marketLocationLabel.numberOfLines = 1;
    self.marketLocationLabel.lineBreakMode = NSLineBreakByClipping;
    self.marketLocationLabel.textAlignment = NSTextAlignmentLeft;
    self.marketLocationLabel.text = self.station.marketLocation;
    
    if ([NPRAudioManager sharedManager].isAudioPlayerToolbarVisible) {
        [self.marketLocationLabel rz_pinnedBottomConstraint].constant += 44.0f;
    }
}

#pragma mark - Actions

- (void)audioPlayerToolbarHeightWillChange:(CGFloat)height {
    [self.marketLocationLabel rz_pinnedBottomConstraint].pop_spring.constant = height + kNPRStationMarketLocationBottomPadding;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webButtonTapped {
    NSURL *url = self.station.homepageUrl;
    
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)facebookButtonTapped {
    NSURL *url = self.station.facebookUrl;
}

- (void)twitterButtonTapped {
    NSURL *url = self.station.twitterUrl;
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

@end
