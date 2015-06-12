//
//  NPRErrorConstants.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRErrorConstants.h"

NSString * const kCLErrorLocationUnknownTitle = @"Location Unknown";
NSString * const kCLErrorDeniedDisabledTitle = @"Disabled";
NSString * const kCLErrorDeniedNotAuthorizedTitle = @"Not Authorized";
NSString * const kCLErrorNetworkTitle = @"Network";

NSString * const kCLErrorLocationUnknownMessage = @"The location manager was unable to obtain a location value right now. Please check your location properties in Settings";
NSString * const kCLErrorDeniedDisabledMessage = @"Please enable Location Services in your device Settings";
NSString * const kCLErrorDeniedNotAuthorizedMessage = @"Please authorize Location Services for this app in your device Settings";
NSString * const kCLErrorNetworkMessage = @"The network was unavailable or a network error occurred.";