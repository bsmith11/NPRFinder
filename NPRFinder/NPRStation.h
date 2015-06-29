//
//  NPRStation.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

@class NPRAudioStream;

typedef NS_ENUM(NSInteger, NPRSignalStrength) {
    NPRSignalStrengthWeak = 1,
    NPRSignalStrengthMedium = 3,
    NPRSignalStrengthStrong = 5
};

@interface NPRStation : NSObject

@property (copy, nonatomic) NSString *GUID;
@property (copy, nonatomic) NSNumber *organizationID;
@property (copy, nonatomic) NSString *call;
@property (copy, nonatomic) NSString *frequency;
@property (copy, nonatomic) NSString *band;
@property (copy, nonatomic) NSString *marketCity;
@property (copy, nonatomic) NSString *marketState;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSURL *homepageURL;
@property (copy, nonatomic) NSURL *pledgePageURL;
@property (copy, nonatomic) NSURL *facebookURL;
@property (copy, nonatomic) NSURL *twitterURL;
@property (copy, nonatomic) NSArray *audioStreams;

@property (assign, nonatomic) NPRSignalStrength signalStrength;
@property (assign, nonatomic, getter=isOpen) BOOL open;
@property (assign, nonatomic, getter=isMusicOnly) BOOL musicOnly;

- (NPRAudioStream *)preferredAudioStream;

@end
