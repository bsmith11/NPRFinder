//
//  NPRStation+RZImport.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStation+RZImport.h"

#import "NPRSwitchConstants.h"
#import "NPRNetworkConstants.h"
#import "NSString+NPRUtil.h"
#import "NPRNetworkManager.h"
#import "NPRAudioStream+RZImport.h"

static const NSInteger kNPRMockStationCount = 10;

typedef NS_ENUM(NSInteger, NPRStationURLType) {
    NPRStationURLTypeOrganizationHomePage = 1,
    NPRStationURLTypeProgramSchedule,
    NPRStationURLTypeOnlineStore,
    NPRStationURLTypePledgePage,
    NPRStationURLTypeENewsletter,
    NPRStationURLTypeLocalNews,
    NPRStationURLTypeAudioStreamLandingPage,
    NPRStationURLTypeRSSFeed,
    NPRStationURLTypePodcast,
    NPRStationURLTypeAudioMP3Stream,
    NPRStationURLTypeAudioWindowsMediaStream,
    NPRStationURLTypeAudioRealMediaStream,
    NPRStationURLTypeAudioAACStream,
    NPRStationURLTypeVideoPodcast,
    NPRStationURLTypeNewscast,
    NPRStationURLTypeFacebookURL,
    NPRStationURLTypeTwitterFeed,
    NPRStationURLTypeStationLogo,
    NPRStationURLTypeStreamLogo,
    NPRStationURLTypeStationIDNPROneAudioIntro,
    NPRStationURLTypeStationHelloAudio,
    NPRStationURLTypeStationSonicIDAudio,
    NPRStationURLTypeStationNPROneLogo,
    NPRStationURLTypeStationIdentifierAudioMP3,
    NPRStationURLTypeStationIdentifierAudioACC
};

@implementation NPRStation (RZImport)

#pragma mark - RZImportable

+ (NSDictionary *)rzi_customMappings {
    return @{kNPRResponseKeyStationOrganizationID:@"organizationID"};
}

+ (NSString *)rzi_dateFormatForKey:(NSString *)key {
    return nil;
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kNPRResponseKeyStationAddress,
             kNPRResponseKeyStationSignal,
             kNPRResponseKeyStationHomepage,
             kNPRResponseKeyStationDonationURL,
             kNPRResponseKeyStationLogo,
             kNPRResponseKeyStationNetwork,
             kNPRResponseKeyStationStatusName,
             kNPRResponseKeyStationAbbreviation,
             kNPRResponseKeyStationTitle,
             kNPRResponseKeyStationTagline,
             kNPRResponseKeyStationFax,
             kNPRResponseKeyStationName,
             kNPRResponseKeyStationPhone,
             kNPRResponseKeyStationPhoneExtension,
             kNPRResponseKeyStationAreaCode,
             kNPRResponseKeyStationFormat];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kNPRResponseKeyStationURLs]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self importURLs:value];
        }
        
        return NO;
    }
    else if ([key isEqualToString:kNPRResponseKeyStationMusicOnly]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.musicOnly = [value boolValue];
        }
        
        return NO;
    }
    else if ([key isEqualToString:kNPRResponseKeyStationSignalStrength]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.signalStrength = [value integerValue];
        }
        
        return NO;
    }
    else if ([key isEqualToString:kNPRResponseKeyStationStatus]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.open = [value boolValue];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)importURLs:(NSArray *)URLs {
    for (NSDictionary *URLDictionary in URLs) {
        NSString *typeId = URLDictionary[kNPRResponseKeyStationURLTypeID];
        NSString *href = URLDictionary[kNPRResponseKeyStationURLHREF];
        NSURL *URL = [NSURL URLWithString:href];
        
        switch ([typeId integerValue]) {
            case NPRStationURLTypeOrganizationHomePage:
                self.homepageURL = URL;
                break;
                
            case NPRStationURLTypePledgePage:
                self.pledgePageURL = URL;
                break;
                
            case NPRStationURLTypeFacebookURL:
                self.facebookURL = URL;
                break;
                
            case NPRStationURLTypeTwitterFeed:
                self.twitterURL = URL;
                break;
                
            case NPRStationURLTypeAudioAACStream:
            case NPRStationURLTypeAudioMP3Stream:
            case NPRStationURLTypeAudioRealMediaStream:
            case NPRStationURLTypeAudioWindowsMediaStream: {
                NPRAudioStream *audioStream = [NPRAudioStream rzi_objectFromDictionary:URLDictionary];
                
                if (audioStream.streamGUID) {
                    self.audioStreams = [self.audioStreams arrayByAddingObject:audioStream];
                }
            }
                break;
                
            default:
                //no-op
                break;
        }
    }
}

#pragma mark - Network Requests

+ (void)getStationsNearLocation:(CLLocation *)location completion:(NPRStationCompletionBlock)completion {
    NSString *coordinates = location ? [NSString npr_coordinatesFromLocation:location] : @"";
    
    [NPRStation getStationsWithSearchText:coordinates completion:completion];
}

+ (void)getStationsWithSearchText:(NSString *)searchText completion:(NPRStationCompletionBlock)completion {
    if (kNPRUseMockStationObjects) {
        NSMutableArray *responseObject = [NSMutableArray array];
        for (NSInteger i = 0; i < kNPRMockStationCount; i++) {
            [responseObject addObject:[NPRStation mockStationJsonWithFrequency:@"89.4" signalStrength:@1]];
        }
        
        [self handleSuccessfulStationRequestWithResponseObject:[responseObject copy] completion:completion];
    }
    else {
        [[NPRNetworkManager sharedManager] searchForStationsWithText:searchText
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 [NPRStation handleSuccessfulStationRequestWithResponseObject:responseObject completion:completion];
                                                             }
                                                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 [NPRStation handleFailedStationRequestWithError:error completion:completion];
                                                             }];
    }
}

#pragma mark - Network Response Handlers

+ (void)handleSuccessfulStationRequestWithResponseObject:(id)responseObject completion:(NPRStationCompletionBlock)completion {
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *responseArray = (NSArray *)responseObject;
        
        if ([[responseArray firstObject] isKindOfClass:[NSString class]]) {
            responseArray = @[];
        }
        
        NSMutableArray *stations = [[NPRStation rzi_objectsFromArray:responseArray] mutableCopy];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"open == YES AND musicOnly == NO"];
        [stations filterUsingPredicate:predicate];
        
        NSSortDescriptor *sortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"signalStrength" ascending:NO];
        [stations sortUsingDescriptors:@[sortDescripter]];
        
        if (completion) {
            completion([stations copy], nil);
        }
    }
    else {
        NSError *error = [NSError errorWithDomain:@"npr_bad_response_object" code:0 userInfo:nil];
        
        if (completion) {
            completion(nil, error);
        }
    }
}

+ (void)handleFailedStationRequestWithError:(NSError *)error completion:(NPRStationCompletionBlock)completion {
    if (completion) {
        completion(nil, error);
    }
}

#pragma mark - Mock Object

+ (NSDictionary *)mockStationURLJSONWithType:(NPRStationURLType)type {
    NSDictionary *json = @{kNPRResponseKeyStationURLTypeID:@(type),
                           kNPRResponseKeyStationURLTypeName:@"Organization Home Page",
                           kNPRResponseKeyStationURLTitle:@"WAMU Homepage",
                           kNPRResponseKeyStationURLHREF:@"http://wamu.org"};
    
    return json;
}

+ (NSDictionary *)mockStationJsonWithFrequency:(NSString *)frequency signalStrength:(NSNumber *)signalStrength {
    NSArray *stationURLs = @[[NPRStation mockStationURLJSONWithType:NPRStationURLTypeOrganizationHomePage],
                             [NPRStation mockStationURLJSONWithType:NPRStationURLTypeFacebookURL],
                             [NPRStation mockStationURLJSONWithType:NPRStationURLTypeTwitterFeed],
                             [NPRStation mockStationURLJSONWithType:NPRStationURLTypeAudioAACStream]];
    
    NSDictionary *json = @{kNPRResponseKeyStationGUID:@"4fcf701003f74f83946fc90857d03ef8",
                           kNPRResponseKeyStationOrganizationID:@"305",
                           kNPRResponseKeyStationName:@"WAMU 88.5",
                           kNPRResponseKeyStationTitle:@"WAMU-FM",
                           kNPRResponseKeyStationCall:@"WAMU",
                           kNPRResponseKeyStationFrequency:frequency,
                           kNPRResponseKeyStationBand:@"FM",
                           kNPRResponseKeyStationTagline:@"The Mind Is Our Medium",
                           kNPRResponseKeyStationAddress:@[@"American University",
                                                            @"4400 Massachusetts Ave., NW",
                                                            @"Washington",
                                                            @"DC",
                                                            @"20016"],
                           kNPRResponseKeyStationMarketCity:@"Washington",
                           kNPRResponseKeyStationMarketState:@"DC",
                           kNPRResponseKeyStationFormat:@"Public Radio",
                           kNPRResponseKeyStationMusicOnly:@"1",
                           kNPRResponseKeyStationStatus:@"1",
                           kNPRResponseKeyStationEmail:@"feedback@wamu.org",
                           kNPRResponseKeyStationAreaCode:[NSNull null],
                           kNPRResponseKeyStationPhone:@"2028851200",
                           kNPRResponseKeyStationPhoneExtension:[NSNull null],
                           kNPRResponseKeyStationFax:@"2028851280",
                           kNPRResponseKeyStationSignal:@"strong",
                           kNPRResponseKeyStationSignalStrength:[signalStrength stringValue],
                           kNPRResponseKeyStationURLs:stationURLs,
                           kNPRResponseKeyStationHomepage:@"http://wamu.org",
                           kNPRResponseKeyStationDonationURL:@"http://wamu.org/support/donate/",
                           kNPRResponseKeyStationLogo:@"http://media.npr.org/images/stations/logos/wamu_fm.gif"};
    
    return json;
}

@end
