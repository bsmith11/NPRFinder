//
//  NPRAudioManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * const kNPRNotificationWillShowAudioPlayerToolbar;
OBJC_EXTERN NSString * const kNPRNotificationWillHideAudioPlayerToolbar;
OBJC_EXTERN NSString * const kNPRNotificationKeyAudioPlayerToolbarHeight;

typedef void(^NPRAnimationCompletionBlock)(BOOL success);

typedef NS_ENUM(NSInteger, NPRAudioManagerState) {
    NPRAudioManagerStatePlaying,
    NPRAudioManagerStatePaused,
    NPRAudioManagerStateLoading,
    NPRAudioManagerStateStopped
};

@class NPRStation;

@interface NPRAudioManager : NSObject

@property (strong, nonatomic, readonly) NPRStation *station;

@property (assign, nonatomic) NPRAudioManagerState state;
@property (assign, nonatomic, getter=isAudioPlayerToolbarVisible, readonly) BOOL audioPlayerToolbarVisible;

+ (instancetype)sharedManager;

- (void)startPlayingStation:(NPRStation *)station;
- (void)play;
- (void)pause;
- (void)stop;

@end
