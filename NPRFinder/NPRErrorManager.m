//
//  NPRErrorManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;
@import CoreLocation;

#import "NPRErrorManager.h"

#import "NPRErrorConstants.h"
#import "NPRSwitchConstants.h"

static NSString * const kNPRErrorAlertCancelButtonTitle = @"OK";
static NSString * const kNPRNetworkErrorResponseKey = @"com.alamofire.serialization.response.error.response";
static NSString * const kNPRNetworkErrorAlertTitle = @"Error";
static NSString * const kNPRNetworkErrorAlertMessageDefault = @"We seem to be having some technical difficulties, please try again later";
static NSString * const kNPRNetworkErrorAlertMessage401 = @"You don't have permission to do that";
static NSString * const kNPRNetworkErrorAlertMessage422 = @"We seem to be having some technical difficulties";
static NSString * const kNPRNetworkErrorAlertMessage500 = @"We seem to be having some technical difficulties";
static NSString * const kNPRLocationErrorLinkText = @"Settings";

@implementation NPRErrorManager

+ (void)showAlertForNetworkError:(NSError *)error {
    NSHTTPURLResponse *response = error.userInfo[kNPRNetworkErrorResponseKey];
    NSInteger statusCode = response.statusCode;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NPRErrorManager titleForNetworkStatusCode:statusCode]
                                                    message:[NPRErrorManager messageForNetworkStatusCode:statusCode]
                                                   delegate:nil
                                          cancelButtonTitle:kNPRErrorAlertCancelButtonTitle
                                          otherButtonTitles:nil];
    if (kNPRShowNetworkErrorAlerts) {
        [alert show];
    }
}

+ (void)showAlertForLocationErrorCode:(NSInteger)code {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NPRErrorManager titleForLocationErrorCode:code]
                                                        message:[NPRErrorManager messageForLocationErrorCode:code]
                                                       delegate:nil
                                              cancelButtonTitle:kNPRErrorAlertCancelButtonTitle
                                              otherButtonTitles:nil];
    
    if (kNPRShowLocationErrorAlerts) {
        [alertView show];
    }
}

+ (NSString *)titleForNetworkStatusCode:(NSInteger)code {
    NSString *title = kNPRNetworkErrorAlertTitle;
    
    return title;
}

+ (NSString *)messageForNetworkStatusCode:(NSInteger)code {
    NSString *message;
    
    switch (code) {
        case 401:
            message = kNPRNetworkErrorAlertMessage401;
            break;
            
        case 422:
            message = kNPRNetworkErrorAlertMessage422;
            break;
            
        case 500:
            message = kNPRNetworkErrorAlertMessage500;
            break;
            
        default:
            message = kNPRNetworkErrorAlertMessageDefault;
            break;
    }
    
    message = kNPRNetworkErrorAlertMessageDefault;
    
    return message;
}

+ (NSString *)titleForLocationErrorCode:(NSInteger)code {
    NSString *title;
    
    switch (code) {
        case kCLErrorLocationUnknown:
            title = kCLErrorLocationUnknownTitle;
            break;
            
        case kCLErrorDenied:
            if ([CLLocationManager locationServicesEnabled]) {
                title = kCLErrorDeniedNotAuthorizedTitle;
            }
            else {
                title = kCLErrorDeniedDisabledTitle;
            }
            break;
            
        case kCLErrorNetwork:
            title = kCLErrorNetworkTitle;
            break;
            
        default:
            title = kCLErrorLocationUnknownTitle;
            break;
    }
    
    return title;
}

+ (NSString *)messageForLocationErrorCode:(NSInteger)code {
    NSString *message;
    
    switch (code) {
        case kCLErrorLocationUnknown:
            message = kCLErrorLocationUnknownMessage;
            break;
            
        case kCLErrorDenied:
            if ([CLLocationManager locationServicesEnabled]) {
                message = kCLErrorDeniedNotAuthorizedMessage;
            }
            else {
                message = kCLErrorDeniedDisabledMessage;
            }
            break;
            
        case kCLErrorNetwork:
            message = kCLErrorNetworkMessage;
            break;
            
        default:
            message = kCLErrorLocationUnknownMessage;
            break;
    }
    
    return message;
}

@end