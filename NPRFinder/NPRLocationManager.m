//
//  NPRLocationManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRLocationManager.h"

#import "NSError+NPRUtil.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) NPRLocationManagerAuthorizationCompletion authorizationCompletion;
@property (copy, nonatomic) NPRLocationManagerCurrentLocationCompletion currentLocationCompletion;

@property (assign, nonatomic) CGFloat accuracyThreshold;

@end

@implementation NPRLocationManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 25.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.activityType = CLActivityTypeOther;
        _locationManager.pausesLocationUpdatesAutomatically = NO;

        _accuracyThreshold = 150.0f;
    }
    
    return self;
}

#pragma mark - Location Services Status

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)locationServicesAlwaysAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return (status == kCLAuthorizationStatusAuthorizedAlways);
}

+ (BOOL)locationServicesWhenInUseAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse);
}

+ (BOOL)locationServicesAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
}

+ (BOOL)locationServicesDetermined {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return (status != kCLAuthorizationStatusNotDetermined);
}

#pragma mark - Accessors / Mutators

- (CLLocation *)location {
    CLLocation *location = self.locationManager.location;
    
    return location;
}

#pragma mark - Permission Requests

- (void)requestAlwaysAuthorizationWithCompletion:(void (^)(CLAuthorizationStatus status))completion {
    self.authorizationCompletion = completion;
    [self.locationManager requestAlwaysAuthorization];
}

- (void)requestWhenInUseAuthorizationWithCompletion:(void (^)(CLAuthorizationStatus status))completion {
    self.authorizationCompletion = completion;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - Current Location Request

- (void)requestCurrentLocationWithCompletion:(void (^)(CLLocation *location, NSError *error))completion {
    self.currentLocationCompletion = completion;

    __block NSError *error = nil;

    if ([NPRLocationManager locationServicesEnabled]) {
        if ([NPRLocationManager locationServicesDetermined]) {
            if ([NPRLocationManager locationServicesAuthorized]) {
                [self.locationManager startUpdatingLocation];
            }
            else {
                error = [NSError npr_locationErrorFromCode:kCLErrorDenied];
            }
        }
        else {
            [self requestWhenInUseAuthorizationWithCompletion:^(CLAuthorizationStatus status) {
                if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                    [self.locationManager startUpdatingLocation];
                }
                else {
                    error = [NSError npr_locationErrorFromCode:kCLErrorDenied];
                    [self locationManager:self.locationManager didFailWithError:error];
                }
            }];
        }
    }
    else {
        error = [NSError npr_locationErrorFromCode:kCLErrorDenied];
    }

    if (error) {
        [self locationManager:self.locationManager didFailWithError:error];
    }
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DDLogInfo(@"didChangeAuthorizationStatus: %@", @(status));

    if (status != kCLAuthorizationStatusNotDetermined) {
        if (self.authorizationCompletion) {
            self.authorizationCompletion(status);
            self.authorizationCompletion = nil;
        }
        else {
            if ([self.delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
                [self.delegate locationManager:self didChangeAuthorizationStatus:status];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DDLogInfo(@"didFailWithError: %@", error);

    if (error.code != kCLErrorLocationUnknown) {
        NSError *locationError = [NSError npr_locationErrorFromCode:error.code];

        if (self.currentLocationCompletion) {
            self.currentLocationCompletion(nil, locationError);
            self.currentLocationCompletion = nil;
        }

        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    DDLogInfo(@"didUpdateLocations: %@", locations);
    
    CLLocation *location = [locations lastObject];

    if (location.horizontalAccuracy < self.accuracyThreshold) {
        if (self.currentLocationCompletion) {
            self.currentLocationCompletion(location, nil);
            self.currentLocationCompletion = nil;
        }

        [self.locationManager stopUpdatingLocation];
    }
}

@end
