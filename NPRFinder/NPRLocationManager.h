//
//  NPRLocationManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import CoreLocation;

OBJC_EXTERN NSString * const kNPRLocationErrorDomain;

typedef NS_ENUM(NSInteger, NPRLocationErrorCode) {
    NPRLocationErrorCodeDisabled,
    NPRLocationErrorCodeDenied
};

typedef void (^NPRLocationManagerAuthorizationCompletion)(CLAuthorizationStatus status);
typedef void (^NPRLocationManagerCurrentLocationCompletion)(CLLocation *location, NSError *error);

@interface NPRLocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

+ (BOOL)locationServicesEnabled;
+ (BOOL)locationServicesAlwaysAuthorized;
+ (BOOL)locationServicesWhenInUseAuthorized;

- (CLLocation *)location;

- (void)requestAlwaysAuthorizationWithCompletion:(NPRLocationManagerAuthorizationCompletion)completion;
- (void)requestWhenInUseAuthorizationWithCompletion:(NPRLocationManagerAuthorizationCompletion)completion;
- (void)requestCurrentLocationWithCompletion:(NPRLocationManagerCurrentLocationCompletion)completion;

@end
