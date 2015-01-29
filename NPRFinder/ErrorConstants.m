//
//  ErrorConstants.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/26/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const kCLErrorLocationUnknownTitle = @"Location Unknown";
NSString * const kCLErrorDeniedDisabledTitle = @"Disabled";
NSString * const kCLErrorDeniedNotAuthorizedTitle = @"Not Authorized";
NSString * const kCLErrorNetworkTitle = @"Network";
NSString * const kCLErrorHeadingFailureTitle = @"Heading Failure";
NSString * const kCLErrorRegionMonitoringDeniedTitle = @"Region Monitoring Denied";
NSString * const kCLErrorRegionMonitoringFailureTitle = @"Region Monitoring Failure";
NSString * const kCLErrorRegionMonitoringSetupDelayedTitle = @"Region Monitoring Setup Delayed";
NSString * const kCLErrorRegionMonitoringResponseDelayedTitle = @"Region Monitoring Response Delayed";
NSString * const kCLErrorGeocodeFoundNoResultTitle = @"Geocode Found No Result";
NSString * const kCLErrorGeocodeFoundPartialResultTitle = @"Geocode Found Partial Result";
NSString * const kCLErrorGeocodeCanceledTitle = @"Geocode Canceled";
NSString * const kCLErrorDeferredFailedTitle = @"Deferred Failed";
NSString * const kCLErrorDeferredNotUpdatingLocationTitle = @"Deferred Not Updating Location";
NSString * const kCLErrorDeferredAccuracyTooLowTitle = @"Deferred Accuracy Too Low";
NSString * const kCLErrorDeferredDistanceFilteredTitle = @"Deferred Distance Filtered";
NSString * const kCLErrorDeferredCanceledTitle = @"Deferred Canceled";
NSString * const kCLErrorRangingUnavailableTitle = @"Ranging Unavailable";
NSString * const kCLErrorRangingFailureTitle = @"Ranging Failure";

NSString * const kCLErrorLocationUnknownMessage = @"The location manager was unable to obtain a location value right now. Please check your location properties in Settings";
NSString * const kCLErrorDeniedDisabledMessage = @"Please enable Location Services in your device Settings";
NSString * const kCLErrorDeniedNotAuthorizedMessage = @"Please authorize Location Services for this app in your device Settings";
NSString * const kCLErrorNetworkMessage = @"The network was unavailable or a network error occurred.";
NSString * const kCLErrorHeadingFailureMessage = @"The heading could not be determined.";
NSString * const kCLErrorRegionMonitoringDeniedMessage = @"Access to the region monitoring service was denied by the user. ";
NSString * const kCLErrorRegionMonitoringFailureMessage = @"A registered region cannot be monitored. Monitoring can fail if the app has exceeded the maximum number of regions that it can monitor simultaneously. Monitoring can also fail if the region’s radius distance is too large.";
NSString * const kCLErrorRegionMonitoringSetupDelayedMessage = @"Core Location could not initialize the region monitoring feature immediately.";
NSString * const kCLErrorRegionMonitoringResponseDelayedMessage = @"Core Location will deliver events but they may be delayed.";
NSString * const kCLErrorGeocodeFoundNoResultMessage = @"The geocode request yielded no result.";
NSString * const kCLErrorGeocodeFoundPartialResultMessage = @"The geocode request yielded a partial result.";
NSString * const kCLErrorGeocodeCanceledMessage = @"The geocode request was canceled.";
NSString * const kCLErrorDeferredFailedMessage = @"The location manager did not enter deferred mode for an unknown reason. This error can occur if GPS is unavailable, not active, or is temporarily interrupted. If you get this error on a device that has GPS hardware, the solution is to try again.";
NSString * const kCLErrorDeferredNotUpdatingLocationMessage = @"The location manager did not enter deferred mode because location updates were already disabled or paused.";
NSString * const kCLErrorDeferredAccuracyTooLowMessage = @"Deferred mode is not supported for the requested accuracy. The accuracy must be set to kCLLocationAccuracyBest or kCLLocationAccuracyBestForNavigation.";
NSString * const kCLErrorDeferredDistanceFilteredMessage = @"Deferred mode does not support distance filters. Set the distance filter to kCLDistanceFilterNone.";
NSString * const kCLErrorDeferredCanceledMessage = @"The request for deferred updates was canceled by your app or by the location manager. This error is returned if you call the disallowDeferredLocationUpdates method or schedule a new deferred update before the previous deferred update request is processed. The location manager may also report this error too. For example, if the app is in the foreground when a new location is determined, the location manager cancels deferred updates and delivers the location data to your app.";
NSString * const kCLErrorRangingUnavailableMessage = @"Ranging is disabled. This might happen if the device is in Airplane mode or if Bluetooth or location services are disabled.";
NSString * const kCLErrorRangingFailureMessage = @"A general ranging error occurred.";