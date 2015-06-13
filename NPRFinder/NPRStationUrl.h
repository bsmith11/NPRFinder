//
//  NPRStationUrl.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NPRStationUrlType) {
    NPRStationUrlTypeOrganizationHomePage = 1,
    NPRStationUrlTypeProgramSchedule,
    NPRStationUrlTypeOnlineStore,
    NPRStationUrlTypePledgePage,
    NPRStationUrlTypeENewsletter,
    NPRStationUrlTypeLocalNews,
    NPRStationUrlTypeAudioStreamLandingPage,
    NPRStationUrlTypeRSSFeed,
    NPRStationUrlTypePodcast,
    NPRStationUrlTypeAudioMP3Stream,
    NPRStationUrlTypeAudioWindowsMediaStream,
    NPRStationUrlTypeAudioRealMediaStream,
    NPRStationUrlTypeAudioAACStream,
    NPRStationUrlTypeVideoPodcast,
    NPRStationUrlTypeNewscast,
    NPRStationUrlTypeFacebookUrl,
    NPRStationUrlTypeTwitterFeed,
    NPRStationUrlTypeStationLogo,
    NPRStationUrlTypeStreamLogo,
    NPRStationUrlTypeStationIDNPROneAudioIntro,
    NPRStationUrlTypeStationHelloAudio,
    NPRStationUrlTypeStationSonicIDAudio,
    NPRStationUrlTypeStationNPROneLogo,
    NPRStationUrlTypeStationIdentifierAudioMP3,
    NPRStationUrlTypeStationIdentifierAudioACC
};

@interface NPRStationUrl : NSObject

@property (copy, nonatomic) NSNumber *typeId;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *url;

@end
