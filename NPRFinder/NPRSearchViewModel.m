//
//  NPRSearchViewModel.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSearchViewModel.h"

#import "NPRStation+RZImport.h"
#import "NSError+NPRUtil.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRSearchViewModel ()

@property (strong, nonatomic, readwrite) NSArray *stations;
@property (strong, nonatomic, readwrite) NSError *error;

@property (assign, nonatomic, readwrite, getter=isSearching) BOOL searching;

@end

@implementation NPRSearchViewModel

#pragma mark - Actions

- (void)searchForStationsWithText:(NSString *)text {
    self.stations = [NSArray array];
    self.searching = YES;
    self.error = nil;

    __weak typeof(self) weakSelf = self;
    [NPRStation getStationsWithSearchText:text completion:^(NSArray *stations, NSError *error) {
        weakSelf.searching = NO;

        if (error) {
            if (error.code == NSURLErrorCancelled) {
                DDLogInfo(@"Search request cancelled");
            }
            else {
                DDLogInfo(@"Failed to find stations with error: %@", error);

                self.error = [NSError npr_networkErrorFromError:error];
                self.stations = [NSArray array];
            }
        }
        else {
            self.stations = stations;

            if ([self.stations count] == 0) {
                self.error = [NSError npr_noResultsError];
            }
        }
    }];
}

@end
