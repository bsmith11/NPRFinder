//
//  NPRAudioManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioManager.h"

#import "NPRStation+RZImport.h"
#import "NPRAudioStream+RZImport.h"
#import "UIScreen+NPRUtil.h"
#import "UIColor+NPRStyle.h"
#import "NPRAudioPlayerToolbar.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>
#import <AVFoundation/AVFoundation.h>
#import <RZDataBinding/RZDataBinding.h>

NSString * const kNPRNotificationWillShowAudioPlayerToolbar = @"npr_notification_will_show_audio_player_toolbar";
NSString * const kNPRNotificationWillHideAudioPlayerToolbar = @"npr_notification_will_hide_audio_player_toolbar";
NSString * const kNPRNotificationKeyAudioPlayerToolbarHeight = @"npr_notification_key_audio_player_toolbar_height";

static const CGFloat kNPRAudioPlayerToolbarHeight = 44.0f;

@interface NPRAudioManager () <NPRAudioPlayerToolbarDelegate>

@property (strong, nonatomic) NPRAudioPlayerToolbar *audioPlayerToolbar;
@property (strong, nonatomic, readwrite) NPRStation *station;
@property (strong, nonatomic) NPRAudioStream *audioStream;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@property (assign, nonatomic, getter=isAudioPlayerToolbarVisible, readwrite) BOOL audioPlayerToolbarVisible;

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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupAudioPlayerToolbar];
        
        _state = NPRAudioManagerStateStopped;
    }
    
    return self;
}

- (void)setState:(NPRAudioManagerState)state {
    if (_state != state) {
        _state = state;
        
        self.audioPlayerToolbar.state = [self audioPlayerToolbarStateForAudioManagerState:state];
    }
}

#pragma mark - Setup

- (void)setupAudioPlayerToolbar {
    CGRect frame = CGRectMake(0.0f, [UIScreen npr_screenHeight], [UIScreen npr_screenWidth], kNPRAudioPlayerToolbarHeight);
    self.audioPlayerToolbar = [[NPRAudioPlayerToolbar alloc] initWithFrame:frame];
    self.audioPlayerToolbar.audioPlayerToolbarDelegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.audioPlayerToolbar];
}

#pragma mark - Actions

- (void)startPlayingStation:(NPRStation *)station {
    NPRAudioStream *audioStream = [station preferredAudioStream];
    
    if ([self.station isEqual:station] && [self.audioStream isEqual:audioStream]) {
        [self play];
    }
    else {
        [self stop];
        
        self.station = station;
        self.audioStream = audioStream;
        
        [self play];
    }
}

- (void)play {
    if (self.station && self.audioStream) {
        switch (self.state) {
            case NPRAudioManagerStatePlaying:
                NSLog(@"Audio stream is already playing");
                break;
                
            case NPRAudioManagerStateLoading:
                NSLog(@"Audio stream is loading");
                break;
                
            case NPRAudioManagerStatePaused:
                [self.audioPlayer play];
                self.state = NPRAudioManagerStatePlaying;
                break;
                
            case NPRAudioManagerStateStopped: {
                NSString *nowPlayingText = [NSString stringWithFormat:@"%@ %@", self.station.call, self.station.frequency];
                self.audioPlayerToolbar.nowPlayingText = nowPlayingText;
                
                self.audioPlayer = [AVPlayer playerWithURL:self.audioStream.URL];
                self.state = NPRAudioManagerStateLoading;
                [self.audioPlayer rz_addTarget:self
                                        action:@selector(audioPlayerStateDidChange:)
                              forKeyPathChange:@"status"
                               callImmediately:YES];
            }
                break;
        }
        
        [self showAudioPlayerToolbarAnimated:YES completion:nil];
    }
    else {
        NSLog(@"Station or audio stream is nil");
        
        self.state = NPRAudioManagerStateStopped;
        
        [self hideAudioPlayerToolbarAnimated:YES completion:nil];
    }
}

- (void)pause {
    if (self.station && self.audioStream) {
        switch (self.state) {
            case NPRAudioManagerStatePlaying:
                [self.audioPlayer pause];
                self.state = NPRAudioManagerStatePaused;
                
                [self showAudioPlayerToolbarAnimated:YES completion:nil];
                break;
                
            case NPRAudioManagerStateLoading:
                NSLog(@"Audio stream is loading");
                
                [self showAudioPlayerToolbarAnimated:YES completion:nil];
                break;
                
            case NPRAudioManagerStatePaused:
                NSLog(@"Audio stream is already paused");
                
                [self showAudioPlayerToolbarAnimated:YES completion:nil];
                break;
                
            case NPRAudioManagerStateStopped:
                NSLog(@"Audio stream is stopped");
                break;
        }
    }
    else {
        NSLog(@"Station or audio stream is nil");
        
        self.state = NPRAudioManagerStateStopped;
        
        [self hideAudioPlayerToolbarAnimated:YES completion:nil];
    }
}

- (void)stop {
    if (self.audioPlayer) {
        [self.audioPlayer pause];
    }
    
    self.state = NPRAudioManagerStateStopped;
    
    self.station = nil;
    self.audioStream = nil;
    self.audioPlayer = nil;
    self.audioPlayerToolbar.nowPlayingText = nil;
    
    [self hideAudioPlayerToolbarAnimated:YES completion:nil];
}

- (void)postWillShowAudioPlayerToolbarNotification {
    NSDictionary *userInfo = @{kNPRNotificationKeyAudioPlayerToolbarHeight:@(kNPRAudioPlayerToolbarHeight)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPRNotificationWillShowAudioPlayerToolbar object:nil userInfo:userInfo];
}

- (void)postWillHideAudioPlayerToolbarNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPRNotificationWillHideAudioPlayerToolbar object:nil userInfo:nil];
}

- (void)audioPlayerStateDidChange:(NSDictionary *)change {
    NSNumber *statusObject = change[kRZDBChangeKeyNew];
    AVPlayerStatus status = [statusObject integerValue];
    
    switch (status) {
        case AVPlayerStatusReadyToPlay:
            NSLog(@"Audio player ready to play");
            
            [self.audioPlayer play];
            self.state = NPRAudioManagerStatePlaying;
            break;
            
        case AVPlayerStatusFailed:
            NSLog(@"Failed to play audio player with error: %@", self.audioPlayer.error);
            
            self.state = NPRAudioManagerStateStopped;
            break;
            
        case AVPlayerStatusUnknown:
            NSLog(@"Audio player status unknown");
            break;
    }
}

- (NPRAudioPlayerToolbarState)audioPlayerToolbarStateForAudioManagerState:(NPRAudioManagerState)state {
    NPRAudioPlayerToolbarState audioPlayerToolbarState;
    
    switch (state) {
        case NPRAudioManagerStatePlaying:
            audioPlayerToolbarState = NPRAudioPlayerToolbarStatePlaying;
            break;
            
        case NPRAudioManagerStatePaused:
            audioPlayerToolbarState = NPRAudioPlayerToolbarStatePaused;
            break;
            
        case NPRAudioManagerStateLoading:
            audioPlayerToolbarState = NPRAudioPlayerToolbarStateLoading;
            break;
            
        case NPRAudioManagerStateStopped:
            audioPlayerToolbarState = NPRAudioPlayerToolbarStateNone;
            break;
    }
    
    return audioPlayerToolbarState;
}

#pragma mark - Audio Player Toolbar Delegate

- (void)audioPlayerToolbarDidSelectPlay:(NPRAudioPlayerToolbar *)audioPlayerToolbar {
    [self play];
}

- (void)audioPlayerToolbarDidSelectPause:(NPRAudioPlayerToolbar *)audioPlayerToolbar {
    [self pause];
}

- (void)audioPlayerToolbarDidSelectStop:(NPRAudioPlayerToolbar *)audioPlayerToolbar {
    [self stop];
}

#pragma mark - Animations

- (void)showAudioPlayerToolbarAnimated:(BOOL)animated completion:(NPRAnimationCompletionBlock)completion {
    if (!self.isAudioPlayerToolbarVisible) {
        self.audioPlayerToolbarVisible = YES;
        
        [self postWillShowAudioPlayerToolbarNotification];
        
        CGRect frame = self.audioPlayerToolbar.frame;
        frame.origin.y = [UIScreen npr_screenHeight] - kNPRAudioPlayerToolbarHeight;
        
        [self animateAudioPlayerToolbarFrame:frame animated:animated completion:completion];
    }
    else {
        if (completion) {
            completion(YES);
        }
    }
}

- (void)hideAudioPlayerToolbarAnimated:(BOOL)animated completion:(NPRAnimationCompletionBlock)completion {
    if (self.isAudioPlayerToolbarVisible) {
        self.audioPlayerToolbarVisible = NO;
        
        [self postWillHideAudioPlayerToolbarNotification];
        
        CGRect frame = self.audioPlayerToolbar.frame;
        frame.origin.y = [UIScreen npr_screenHeight];
        
        [self animateAudioPlayerToolbarFrame:frame animated:animated completion:completion];
    }
    else {
        if (completion) {
            completion(YES);
        }
    }
}

- (void)animateAudioPlayerToolbarFrame:(CGRect)frame animated:(BOOL)animated completion:(NPRAnimationCompletionBlock)completion {
    if (animated) {
        [NSObject pop_animate:^{
            self.audioPlayerToolbar.pop_spring.frame = frame;
        } completion:completion];
    }
    else {
        self.audioPlayerToolbar.frame = frame;
        
        if (completion) {
            completion(YES);
        }
    }
}

@end
