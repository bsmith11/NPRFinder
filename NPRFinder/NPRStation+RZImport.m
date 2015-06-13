//
//  NPRStation+RZImport.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStation+RZImport.h"

#import "NPRStationUrl+RZImport.h"
#import "NPRSwitchConstants.h"
#import "NPRNetworkConstants.h"
#import "NSString+NPRUtil.h"
#import "NPRNetworkManager.h"

static const NSInteger kNPRMockStationCount = 10;

@implementation NPRStation (RZImport)

#pragma mark - RZImportable

+ (NSDictionary *)rzi_customMappings {
    return @{kNPRResponseKeyStationOrganizationId:@"organizationId"};
}

+ (NSString *)rzi_dateFormatForKey:(NSString *)key {
    return nil;
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kNPRResponseKeyStationAddress,
             kNPRResponseKeyStationSignal,
             kNPRResponseKeyStationHomepage,
             kNPRResponseKeyStationDonationUrl,
             kNPRResponseKeyStationLogo];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kNPRResponseKeyStationUrls]) {
        if ([value isKindOfClass:[NSArray class]]) {
            self.urls = [NPRStationUrl rzi_objectsFromArray:value];
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

#pragma mark - Network Requests

+ (void)getStationsNearLocation:(CLLocation *)location completion:(NPRStationCompletionBlock)completion {
    NSString *coordinates = [NSString npr_coordinatesFromLocation:location];
    
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
        NSMutableArray *stations = [[NPRStation rzi_objectsFromArray:responseObject] mutableCopy];
        
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

+ (NSDictionary *)mockStationJsonWithFrequency:(NSString *)frequency signalStrength:(NSNumber *)signalStrength {
    NSArray *stationUrls = @[[NPRStationUrl mockStationUrlJSONWithTypeId:@(1)],
                             [NPRStationUrl mockStationUrlJSONWithTypeId:@(2)],
                             [NPRStationUrl mockStationUrlJSONWithTypeId:@(3)],
                             [NPRStationUrl mockStationUrlJSONWithTypeId:@(4)]];
    
    NSDictionary *json = @{kNPRResponseKeyStationGUID:@"4fcf701003f74f83946fc90857d03ef8",
                           kNPRResponseKeyStationOrganizationId:@"305",
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
                           kNPRResponseKeyStationMusicOnly:@"0",
                           kNPRResponseKeyStationStatus:@"1",
                           kNPRResponseKeyStationEmail:@"feedback@wamu.org",
                           kNPRResponseKeyStationAreaCode:[NSNull null],
                           kNPRResponseKeyStationPhone:@"2028851200",
                           kNPRResponseKeyStationPhoneExtension:[NSNull null],
                           kNPRResponseKeyStationFax:@"2028851280",
                           kNPRResponseKeyStationSignal:@"strong",
                           kNPRResponseKeyStationSignalStrength:[signalStrength stringValue],
                           kNPRResponseKeyStationUrls:stationUrls,
                           kNPRResponseKeyStationHomepage:@"http://wamu.org",
                           kNPRResponseKeyStationDonationUrl:@"http://wamu.org/support/donate/",
                           kNPRResponseKeyStationLogo:@"http://media.npr.org/images/stations/logos/wamu_fm.gif"};
    
    return json;
}

@end
