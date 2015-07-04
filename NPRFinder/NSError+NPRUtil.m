//
//  NSError+NPRUtil.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/3/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import CoreLocation;

#import "NSError+NPRUtil.h"

NSString * const kNPRErrorTextKey = @"npr_error_text_key";
NSString * const kNPRErrorActionKey = @"npr_error_action_key";

static NSString * const kNPRErrorDomain = @"com.NPRFinder.NoResultsError";

static NSString * const kNPRErrorLocationUnknownText = @"We are having trouble finding your location";
static NSString * const kNPRErrorLocationNetworkText = @"We are having trouble finding your location";
static NSString * const kNPRErrorLocationDisabledText = @"You have location services turned off";
static NSString * const kNPRErrorLocationDeniedText = @"You have denied us permission to use your location";
static NSString * const kNPRErrorLocationAction = @"Settings";

static NSString * const kNPRErrorNetworkText = @"The server just exploded...";

static NSString * const kNPRErrorNoResultsText = @"No stations found";

@implementation NSError (NPRUtil)

+ (NSError *)npr_locationErrorFromCode:(NSInteger)code {
    NSString *errorLocationText = [NSError textForLocationErrorCode:code];
    NSDictionary *userInfo = @{kNPRErrorTextKey:errorLocationText,
                               kNPRErrorActionKey:kNPRErrorLocationAction};
    NSError *locationError = [NSError errorWithDomain:kNPRErrorDomain code:code userInfo:userInfo];

    return locationError;
}

+ (NSError *)npr_networkErrorFromError:(NSError *)error {
    NSDictionary *userInfo = @{kNPRErrorTextKey:kNPRErrorNetworkText};
    NSError *networkError = [NSError errorWithDomain:kNPRErrorDomain code:error.code userInfo:userInfo];

    return networkError;
}

+ (NSError *)npr_noResultsError {
    NSDictionary *userInfo = @{kNPRErrorTextKey:kNPRErrorNoResultsText};
    NSError *error = [NSError errorWithDomain:kNPRErrorDomain code:0 userInfo:userInfo];

    return error;
}

+ (NSString *)textForLocationErrorCode:(NSInteger)code {
    NSString *text = @"";

    switch (code) {
        case kCLErrorLocationUnknown:
            text = kNPRErrorLocationUnknownText;
            break;

        case kCLErrorDenied:
            if ([CLLocationManager locationServicesEnabled]) {
                text = kNPRErrorLocationDeniedText;
            }
            else {
                text = kNPRErrorLocationDisabledText;
            }
            break;

        case kCLErrorNetwork:
            text = kNPRErrorLocationNetworkText;
            break;

        default:
            text = kNPRErrorLocationUnknownText;
            break;
    }

    return text;
}

@end
