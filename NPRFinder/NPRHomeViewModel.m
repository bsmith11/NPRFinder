//
//  NPRHomeViewModel.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/2/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeViewModel.h"

#import "NPRStation+RZImport.h"
#import "NSError+NPRUtil.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRHomeViewModel ()

@property (strong, nonatomic, readwrite) NSArray *stations;
@property (strong, nonatomic, readwrite) NSError *error;

@property (assign, nonatomic, readwrite, getter=isSearching) BOOL searching;

@end

@implementation NPRHomeViewModel

- (void)searchForStationsNearCurrentLocation {
    self.searching = YES;

    __weak typeof(self) weakSelf = self;
    [[NPRLocationManager sharedManager] requestCurrentLocationWithCompletion:^(CLLocation *location, NSError *error) {
        if (error) {
            weakSelf.searching = NO;

            weakSelf.error = error;
            weakSelf.stations = [NSArray array];
        }
        else {
            [weakSelf searchForStationsNearLocation:location];
        }
    }];
}

- (void)searchForStationsNearLocation:(CLLocation *)location {
    self.searching = YES;

    DDLogInfo(@"Searching for stations near location: %@", location);

    __weak typeof(self) weakSelf = self;
    [NPRStation getStationsNearLocation:location completion:^(NSArray *stations, NSError *error) {
        weakSelf.searching = NO;

        if (error) {
            if (error.code == NSURLErrorCancelled) {
                DDLogInfo(@"Search request cancelled");
            }
            else {
                DDLogInfo(@"Failed to find stations with error: %@", error);

                weakSelf.error = [NSError npr_networkErrorFromError:error];
                weakSelf.stations = [NSArray array];
            }
        }
        else {
            weakSelf.stations = stations;

            if ([weakSelf.stations count] == 0) {
                weakSelf.error = [NSError npr_noResultsError];
            }
        }
    }];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(NPRLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    self.error = nil;
    [self searchForStationsNearCurrentLocation];
}

@end
