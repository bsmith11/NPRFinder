//
//  NPRHomeViewModel.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/2/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface NPRHomeViewModel : NSObject

@property (strong, nonatomic, readonly) NSArray *stations;
@property (strong, nonatomic, readonly) NSError *error;

@property (assign, nonatomic, readonly, getter=isSearching) BOOL searching;

- (void)searchForStationsNearLocation:(CLLocation *)location;

@end
