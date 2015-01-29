//
//  ErrorManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "ErrorManager.h"
#import "ErrorConstants.h"
#import "SwitchConstants.h"
#import "UIFont+NPRFinder.h"
#import "UIColor+NPRFinder.h"

static NSString * const kErrorAlertCancelButtonTitle = @"OK";
static NSString * const kNetworkErrorResponseKey = @"com.alamofire.serialization.response.error.response";
static NSString * const kNetworkErrorAlertTitle = @"Error";
static NSString * const kNetworkErrorAlertMessageDefault = @"We seem to be having some technical difficulties, please try again later";
static NSString * const kNetworkErrorAlertMessage401 = @"You don't have permission to do that";
static NSString * const kNetworkErrorAlertMessage422 = @"We seem to be having some technical difficulties";
static NSString * const kNetworkErrorAlertMessage500 = @"We seem to be having some technical difficulties";
static NSString * const kLocationErrorLinkText = @"Settings";

@implementation ErrorManager

+ (void)setupLabel:(TTTAttributedLabel *)label locationError:(NSError *)error {
    NSInteger code = error.code;
    NSString *errorTitle = [ErrorManager titleForLocationErrorCode:code];
    NSString *errorMessage = [ErrorManager messageForLocationErrorCode:code];
    
    [label setText:[NSString stringWithFormat:@"%@\n%@", errorTitle, errorMessage] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange titleRange = [[mutableAttributedString string] rangeOfString:errorTitle];
        NSRange messageRange = [[mutableAttributedString string] rangeOfString:errorMessage];
        NSRange settingsRange = [[mutableAttributedString string] rangeOfString:kLocationErrorLinkText];
        
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont npr_errorTitleFont] range:titleRange];
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont npr_errorMessageFont] range:messageRange];
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont npr_errorLinkFont] range:settingsRange];
        
        return mutableAttributedString;
    }];
    
    [label setLinkAttributes:@{NSFontAttributeName:[UIFont npr_errorLinkFont],
                               NSForegroundColorAttributeName:[UIColor npr_foregroundColor]}];
    [label setActiveLinkAttributes:@{NSFontAttributeName:[UIFont npr_errorLinkFont],
                                     NSForegroundColorAttributeName:[UIColor npr_greyColor]}];
    
    NSRange settingsRange = [label.text rangeOfString:kLocationErrorLinkText];
    NSURL *url = nil;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    
    [label addLinkToURL:url withRange:settingsRange];
}

+ (void)setupLabel:(TTTAttributedLabel *)label networkError:(NSError *)error {
    NSHTTPURLResponse *response = error.userInfo[kNetworkErrorResponseKey];
    NSInteger code = response.statusCode;
    NSString *errorTitle = [ErrorManager titleForNetworkStatusCode:code];
    NSString *errorMessage = [ErrorManager messageForNetworkStatusCode:code];
    
    [label setText:[NSString stringWithFormat:@"%@\n%@", errorTitle, errorMessage] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange titleRange = [[mutableAttributedString string] rangeOfString:errorTitle];
        NSRange messageRange = [[mutableAttributedString string] rangeOfString:errorMessage];
        
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont npr_errorTitleFont] range:titleRange];
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont npr_errorMessageFont] range:messageRange];
        
        return mutableAttributedString;
    }];
}

+ (void)showAlertForNetworkError:(NSError *)error {
    NSHTTPURLResponse *response = error.userInfo[kNetworkErrorResponseKey];
    NSInteger statusCode = response.statusCode;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[ErrorManager titleForNetworkStatusCode:statusCode]
                                                    message:[ErrorManager messageForNetworkStatusCode:statusCode]
                                                   delegate:nil
                                          cancelButtonTitle:kErrorAlertCancelButtonTitle
                                          otherButtonTitles:nil];
    if (kShowNetworkErrorAlerts) {
        [alert show];
    }
}

+ (void)showAlertForLocationErrorCode:(NSInteger)code {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[ErrorManager titleForLocationErrorCode:code]
                                                        message:[ErrorManager messageForLocationErrorCode:code]
                                                       delegate:nil
                                              cancelButtonTitle:kErrorAlertCancelButtonTitle
                                              otherButtonTitles:nil];
    
    if (kShowLocationErrorAlerts) {
        [alertView show];
    }
}

+ (NSString *)titleForNetworkStatusCode:(NSInteger)code {
    NSString *title;
    
//    switch (code) {
//        case 401:
//            title = kNetworkErrorAlertMessage401;
//            DDLogInfo(@"401: Unauthorized\nMessage: %@", message);
//            break;
//            
//        case 422:
//            title = kNetworkErrorAlertMessage422;
//            DDLogInfo(@"422: Bad Request\nMessage: %@", message);
//            break;
//            
//        case 500:
//            title = kNetworkErrorAlertMessage500;
//            DDLogInfo(@"500: Internal Server Error\nMessage: %@", message);
//            break;
//            
//        default:
//            title = kNetworkErrorAlertMessageDefault;
//            DDLogInfo(@"%ld: Unknown Error Code\nMessage: %@", (long)code, message);
//            break;
//    }
    
    title = kNetworkErrorAlertTitle;
    
    return title;
}

+ (NSString *)messageForNetworkStatusCode:(NSInteger)code {
    NSString *message;
    
    switch (code) {
        case 401:
            message = kNetworkErrorAlertMessage401;
            DDLogInfo(@"401: Unauthorized\nMessage: %@", message);
            break;
            
        case 422:
            message = kNetworkErrorAlertMessage422;
            DDLogInfo(@"422: Bad Request\nMessage: %@", message);
            break;
            
        case 500:
            message = kNetworkErrorAlertMessage500;
            DDLogInfo(@"500: Internal Server Error\nMessage: %@", message);
            break;
            
        default:
            message = kNetworkErrorAlertMessageDefault;
            DDLogInfo(@"%ld: Unknown Error Code\nMessage: %@", (long)code, message);
            break;
    }
    
    message = kNetworkErrorAlertMessageDefault;
    
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
            
        case kCLErrorHeadingFailure:
            title = kCLErrorHeadingFailureTitle;
            break;
            
        case kCLErrorRegionMonitoringDenied:
            title = kCLErrorRegionMonitoringDeniedTitle;
            break;
            
        case kCLErrorRegionMonitoringFailure:
            title = kCLErrorRegionMonitoringFailureTitle;
            break;
            
        case kCLErrorRegionMonitoringSetupDelayed:
            title = kCLErrorRegionMonitoringSetupDelayedTitle;
            break;
            
        case kCLErrorRegionMonitoringResponseDelayed:
            title = kCLErrorRegionMonitoringResponseDelayedTitle;
            break;
            
        case kCLErrorGeocodeFoundNoResult:
            title = kCLErrorGeocodeFoundNoResultTitle;
            break;
            
        case kCLErrorGeocodeFoundPartialResult:
            title = kCLErrorGeocodeFoundPartialResultTitle;
            break;
            
        case kCLErrorGeocodeCanceled:
            title = kCLErrorGeocodeCanceledTitle;
            break;
            
        case kCLErrorDeferredFailed:
            title = kCLErrorDeferredFailedTitle;
            break;
            
        case kCLErrorDeferredNotUpdatingLocation:
            title = kCLErrorDeferredNotUpdatingLocationTitle;
            break;
            
        case kCLErrorDeferredAccuracyTooLow:
            title = kCLErrorDeferredAccuracyTooLowTitle;
            break;
            
        case kCLErrorDeferredDistanceFiltered:
            title = kCLErrorDeferredDistanceFilteredTitle;
            break;
            
        case kCLErrorDeferredCanceled:
            title = kCLErrorDeferredCanceledTitle;
            break;
            
        case kCLErrorRangingUnavailable:
            title = kCLErrorRangingUnavailableTitle;
            break;
            
        case kCLErrorRangingFailure:
            title = kCLErrorRangingFailureTitle;
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
            
        case kCLErrorHeadingFailure:
            message = kCLErrorHeadingFailureMessage;
            break;
            
        case kCLErrorRegionMonitoringDenied:
            message = kCLErrorRegionMonitoringDeniedMessage;
            break;
            
        case kCLErrorRegionMonitoringFailure:
            message = kCLErrorRegionMonitoringFailureMessage;
            break;
            
        case kCLErrorRegionMonitoringSetupDelayed:
            message = kCLErrorRegionMonitoringSetupDelayedMessage;
            break;
            
        case kCLErrorRegionMonitoringResponseDelayed:
            message = kCLErrorRegionMonitoringResponseDelayedMessage;
            break;
            
        case kCLErrorGeocodeFoundNoResult:
            message = kCLErrorGeocodeFoundNoResultMessage;
            break;
            
        case kCLErrorGeocodeFoundPartialResult:
            message = kCLErrorGeocodeFoundPartialResultMessage;
            break;
            
        case kCLErrorGeocodeCanceled:
            message = kCLErrorGeocodeCanceledMessage;
            break;
            
        case kCLErrorDeferredFailed:
            message = kCLErrorDeferredFailedMessage;
            break;
            
        case kCLErrorDeferredNotUpdatingLocation:
            message = kCLErrorDeferredNotUpdatingLocationMessage;
            break;
            
        case kCLErrorDeferredAccuracyTooLow:
            message = kCLErrorDeferredAccuracyTooLowMessage;
            break;
            
        case kCLErrorDeferredDistanceFiltered:
            message = kCLErrorDeferredDistanceFilteredMessage;
            break;
            
        case kCLErrorDeferredCanceled:
            message = kCLErrorDeferredCanceledMessage;
            break;
            
        case kCLErrorRangingUnavailable:
            message = kCLErrorRangingUnavailableMessage;
            break;
            
        case kCLErrorRangingFailure:
            message = kCLErrorRangingFailureMessage;
            break;
            
        default:
            message = kCLErrorLocationUnknownMessage;
            break;
    }
    
    return message;
}

@end
