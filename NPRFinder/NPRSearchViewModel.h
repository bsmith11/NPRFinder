//
//  NPRSearchViewModel.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

@interface NPRSearchViewModel : NSObject

@property (strong, nonatomic, readonly) NSArray *stations;
@property (strong, nonatomic, readonly) NSError *error;

@property (assign, nonatomic, readonly, getter=isSearching) BOOL searching;

- (void)searchForStationsWithText:(NSString *)text;

@end
