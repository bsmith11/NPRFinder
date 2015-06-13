//
//  NPRAudioManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioManager.h"

#import "NPRStation+RZImport.h"
#import "UIScreen+NPRUtil.h"
#import "UIColor+NPRStyle.h"
#import "NPRAudioPlayerToolbar.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>

typedef NS_ENUM(NSInteger, NPRAudioManagerState) {
    NPRAudioManagerStatePlaying,
    NPRAudioManagerStatePaused,
    NPRAudioManagerStateStopped
};

NSString * const kNPRNotificationWillShowAudioPlayerToolbar = @"npr_notification_will_show_audio_player_toolbar";
NSString * const kNPRNotificationWillHideAudioPlayerToolbar = @"npr_notification_will_hide_audio_player_toolbar";
NSString * const kNPRNotificationKeyAudioPlayerToolbarHeight = @"npr_notification_key_audio_player_toolbar_height";

static const CGFloat kNPRAudioPlayerToolbarHeight = 44.0f;

@interface NPRAudioManager () <NPRAudioPlayerToolbarDelegate>

@property (strong, nonatomic) NPRAudioPlayerToolbar *audioPlayerToolbar;
@property (strong, nonatomic) NPRStation *station;

@property (assign, nonatomic) NPRAudioManagerState state;
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
        _state = NPRAudioManagerStateStopped;
        
        [self setupAudioPlayerToolbar];
    }
    
    return self;
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
    switch (self.state) {
        case NPRAudioManagerStatePlaying:
            [self stop];
            break;
            
        case NPRAudioManagerStatePaused:
            [self stop];
            break;
            
        case NPRAudioManagerStateStopped:
            //no-op
            break;
    }
    
    self.station = station;
    
    [self play];
    
    if (!self.isAudioPlayerToolbarVisible) {
        [self showAudioPlayerToolbarAnimated:YES completion:nil];
    }
}

- (void)play {
    if (self.station && self.state != NPRAudioManagerStatePlaying) {
        self.state = NPRAudioManagerStatePlaying;
        
        self.audioPlayerToolbar.nowPlayingText = self.station.name;
        
        //play
    }
}

- (void)pause {
    if (self.station && self.state != NPRAudioManagerStatePaused) {
        self.state = NPRAudioManagerStatePaused;
        
        //pause
    }
}

- (void)stop {
    if (self.station) {
        self.station = nil;
    }
    
    self.state = NPRAudioManagerStateStopped;
    
    //stop
}

- (NPRStation *)currentPlayingStation {
    return self.station;
}

- (void)postWillShowAudioPlayerToolbarNotification {
    NSDictionary *userInfo = @{kNPRNotificationKeyAudioPlayerToolbarHeight:@(kNPRAudioPlayerToolbarHeight)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPRNotificationWillShowAudioPlayerToolbar object:nil userInfo:userInfo];
}

- (void)postWillHideAudioPlayerToolbarNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPRNotificationWillHideAudioPlayerToolbar object:nil userInfo:nil];
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
    
    [self hideAudioPlayerToolbarAnimated:YES completion:nil];
}

#pragma mark - Animations

- (void)showAudioPlayerToolbarAnimated:(BOOL)animated completion:(NPRAnimationCompletionBlock)completion {
    [self postWillShowAudioPlayerToolbarNotification];
    
    self.audioPlayerToolbarVisible = YES;
    
    CGRect frame = self.audioPlayerToolbar.frame;
    frame.origin.y = [UIScreen npr_screenHeight] - kNPRAudioPlayerToolbarHeight;
    
    [self animateAudioPlayerToolbarFrame:frame animated:animated completion:completion];
}

- (void)hideAudioPlayerToolbarAnimated:(BOOL)animated completion:(NPRAnimationCompletionBlock)completion {
    [self postWillHideAudioPlayerToolbarNotification];
    
    self.audioPlayerToolbarVisible = NO;
    
    CGRect frame = self.audioPlayerToolbar.frame;
    frame.origin.y = [UIScreen npr_screenHeight];
    
    [self animateAudioPlayerToolbarFrame:frame animated:animated completion:completion];
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
