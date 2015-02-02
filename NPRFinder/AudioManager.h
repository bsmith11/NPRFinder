//
//  AudioManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Station;

@interface AudioManager : NSObject

+ (instancetype)sharedManager;

- (void)startPlayingStation:(Station *)station;
- (void)stop;
- (Station *)currentPlayingStation;

@end
