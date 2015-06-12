//
//  NPRSearchViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSearchViewController.h"

#import "NPRStation+RZImport.h"
#import "NPRErrorManager.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

static NSString * const kSearchTextFieldPlaceholderText = @"Search for stations";

@interface NPRSearchViewController ()

@property (strong, nonatomic) NSArray *stations;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation NPRSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.stations = [NSArray array];
    
    [self setupCloseButton];
    [self setupSearchTextField];
}

#pragma mark - Setup

- (void)setupCloseButton {

}

- (void)setupSearchTextField {
    [self.searchTextField addTarget:self
                             action:@selector(searchTextFieldValueChanged:)
                   forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Actions

- (void)closeButtonPressed {
    [self.searchTextField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextFieldValueChanged:(UITextField *)textField {
    NSString *text = textField.text;
    
    if ([text length] > 0) {
        [self searchForStationsWithText:text];
    }
    else {
        self.stations = [NSArray array];
    }
}

- (void)searchForStationsWithText:(NSString *)text {
    [NPRStation getStationsWithSearchText:text completion:^(NSArray *stations, NSError *error) {
        if (error) {
            if (error.code == NSURLErrorCancelled) {
                DDLogInfo(@"Search request cancelled");
            }
            else {
                [NPRErrorManager showAlertForNetworkError:error];
            }
        }
        else {
            self.stations = stations;
        }
    }];
}

@end
