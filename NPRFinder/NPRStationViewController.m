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

static NSString * const kFacebookProfileUrl = @"fb://profile/%@";
static NSString * const kTwitterProfileUrl = @"twitter://user?id=%@";

@interface NPRStationViewController ()

@property (strong, nonatomic) NSArray *programs;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NPRStation *station;

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
    
    self.programs = [NSArray array];
    
    [self downloadPrograms];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(40, 40, 40, 40);
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

#pragma mark - Actions

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
