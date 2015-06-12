//
//  NPRAudioManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioManager.h"
#import "NPRStation+RZImport.h"

@interface NPRAudioManager ()

@property (copy, nonatomic) NPRStation *station;

@property (assign, nonatomic, getter=isPlaying) BOOL playing;

@end

@implementation NPRAudioManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Actions

- (void)startPlayingStation:(NPRStation *)station {
    [self stop];
    
    self.playing = YES;
    
    self.station = station;
}

- (void)stop {
    self.playing = NO;
    self.station = nil;
}

- (NPRStation *)currentPlayingStation {
    return self.station;
}

@end
