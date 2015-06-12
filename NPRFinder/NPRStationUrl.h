//
//  NPRStationUrl.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StationUrlType) {
    StationUrlTypeOrganizationHomePage = 1,
    StationUrlTypeProgramSchedule,
    StationUrlTypeOnlineStore,
    StationUrlTypePledgePage,
    StationUrlTypeENewsletter,
    StationUrlTypeLocalNews,
    StationUrlTypeAudioStreamLandingPage,
    StationUrlTypeRSSFeed,
    StationUrlTypePodcast,
    StationUrlTypeAudioMP3Stream,
    StationUrlTypeAudioWindowsMediaStream,
    StationUrlTypeAudioRealMediaStream,
    StationUrlTypeAudioAACStream,
    StationUrlTypeVideoPodcast,
    StationUrlTypeNewscast,
    StationUrlTypeFacebookUrl,
    StationUrlTypeTwitterFeed,
    StationUrlTypeStationLogo,
    StationUrlTypeStreamLogo,
    StationUrlTypeStationIDNPROneAudioIntro,
    StationUrlTypeStationHelloAudio,
    StationUrlTypeStationSonicIDAudio,
    StationUrlTypeStationNPROneLogo,
    StationUrlTypeStationIdentifierAudioMP3,
    StationUrlTypeStationIdentifierAudioACC
};

@interface NPRStationUrl : NSObject

@property (copy, nonatomic) NSNumber *typeId;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *url;

@end
