//
//  NPRStationViewModel.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationViewModel.h"

@interface NPRStationViewModel ()

@property (strong, nonatomic, readwrite) NPRStation *station;

@end

@implementation NPRStationViewModel

#pragma mark - Lifecycle

- (instancetype)initWithStation:(NPRStation *)station {
    self = [super init];

    if (self) {
        _station = station;
    }

    return self;
}

@end
