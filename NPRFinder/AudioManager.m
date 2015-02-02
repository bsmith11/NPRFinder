//
//  AudioManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "AudioManager.h"
#import "Station.h"

@interface AudioManager ()

@property (copy, nonatomic) Station *station;

@property (assign, nonatomic) BOOL isPlaying;

@end

@implementation AudioManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    
    return sharedManager;
}

#pragma mark - Actions

- (void)startPlayingStation:(Station *)station {
    [self stop];
    
    self.isPlaying = YES;
    
    self.station = station;
}

- (void)stop {
    self.isPlaying = NO;
    self.station = nil;
}

- (Station *)currentPlayingStation {
    return self.station;
}

@end
