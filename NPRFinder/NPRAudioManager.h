//
//  NPRAudioManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NPRStation;

@interface NPRAudioManager : NSObject

+ (instancetype)sharedManager;

- (void)startPlayingStation:(NPRStation *)station;
- (void)stop;
- (NPRStation *)currentPlayingStation;

@end
