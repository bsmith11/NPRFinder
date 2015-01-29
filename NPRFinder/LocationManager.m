//
//  LocationManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationManager.h"
#import "ErrorManager.h"
#import "NotificationManager.h"
#import "SwitchConstants.h"

static NSString * const kIsUpdatingLocationKey = @"npr_is_updating_location";
static NSString * const kIsMonitoringSignificantLocationChangesKey = @"npr_is_monitoring_significant_location_changes";
static NSString * const kLastUpdateDateKey = @"npr_last_update_date";

@interface LocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) NSDate *lastUpdateDate;

@property (assign, nonatomic) BOOL isRunning;
@property (assign, nonatomic) BOOL isRequestingAuthorization;
@property (assign, nonatomic) BOOL isUpdatingLocation;
@property (assign, nonatomic) BOOL isMonitoringSignificantLocationChanges;
@property (assign, nonatomic) CGFloat accuracyThreshold;
@property (assign, nonatomic) CGFloat timePassedThreshold;

@end

@implementation LocationManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationManager = [CLLocationManager new];
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:25.0];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [_locationManager setActivityType:CLActivityTypeOther];
        [_locationManager setPausesLocationUpdatesAutomatically:YES];
        
        _isRunning = NO;
        _isRequestingAuthorization = NO;
        _accuracyThreshold = 150.0;
        _timePassedThreshold = 5.0;
        
        [self setIsUpdatingLocation:NO];
        [self setIsMonitoringSignificantLocationChanges:NO];
    }
    
    return self;
}

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)locationServicesAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
}

+ (BOOL)locationServicesDetermined {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return (status != kCLAuthorizationStatusNotDetermined);
}

+ (BOOL)backgroundAppRefreshEnabled {
    UIBackgroundRefreshStatus status = [[UIApplication sharedApplication] backgroundRefreshStatus];
    
    return (status == UIBackgroundRefreshStatusAvailable);
}

#pragma mark - Accessors / Mutators

- (CLLocation *)location {
    CLLocation *location = self.locationManager.location;
    
    return location;
}

- (BOOL)isRunning {
    return _isRunning;
}

- (NSDate *)lastUpdateDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:kLastUpdateDateKey];
}

- (void)setLastUpdateDate:(NSDate *)lastUpdateDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastUpdateDate forKey:kLastUpdateDateKey];
    [userDefaults synchronize];
}

- (BOOL)isUpdatingLocation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults boolForKey:kIsUpdatingLocationKey];
}

- (void)setIsUpdatingLocation:(BOOL)isUpdatingLocation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isUpdatingLocation forKey:kIsUpdatingLocationKey];
    [userDefaults synchronize];
}

- (BOOL)isMonitoringSignificantLocationChanges {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults boolForKey:kIsMonitoringSignificantLocationChangesKey];
}

- (void)setIsMonitoringSignificantLocationChanges:(BOOL)isMonitoringSignificantLocationChanges {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isMonitoringSignificantLocationChanges forKey:kIsMonitoringSignificantLocationChangesKey];
    [userDefaults synchronize];
}

#pragma mark - Permissions

- (void)requestAlwaysAuthorization {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)requestWhenInUseAuthorization {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Location Monitoring

- (void)start {
    if (!self.isRunning) {
        if ([LocationManager locationServicesDetermined]) {
            if ([LocationManager locationServicesEnabled] && [LocationManager locationServicesAuthorized]) {
                self.isRunning = YES;
                
                [self startUpdatingLocation];
            }
            else {
                NSError *error = [NSError errorWithDomain:@"" code:kCLErrorDenied userInfo:nil];
                [self locationManager:self.locationManager didFailWithError:error];
            }
        }
        else {
            self.isRequestingAuthorization = YES;
            
            if (kRequestLocationServicesRequestAlwaysAuthorization) {
                [self requestAlwaysAuthorization];
            }
            else {
                [self requestWhenInUseAuthorization];
            }
        }
    }
}

- (void)stop {
    if (self.isRunning) {
        self.isRunning = NO;
        
        [self stopUpdatingLocation];
        [self stopMonitoringSignificantLocationChanges];
    }
}

- (void)startUpdatingLocation {
    if (!self.isUpdatingLocation) {
        [NotificationManager scheduleLocationUpdatesStartLocalNotification];
        
        [self stopMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        self.isUpdatingLocation = YES;
    }
}

- (void)stopUpdatingLocation {
    if (self.isUpdatingLocation) {
        [NotificationManager scheduleLocationUpdatesStopLocalNotification];
        
        [self.locationManager stopUpdatingLocation];
        self.isUpdatingLocation = NO;
    }
}

- (void)startMonitoringSignificantLocationChanges {
    if (!self.isMonitoringSignificantLocationChanges && kMonitorSignificantLocationChanges) {
        [NotificationManager scheduleSignificantLocationChangesStartLocalNotification];
        
        [self stopUpdatingLocation];
        [self.locationManager startMonitoringSignificantLocationChanges];
        self.isMonitoringSignificantLocationChanges = YES;
    }
}

- (void)stopMonitoringSignificantLocationChanges {
    if (self.isMonitoringSignificantLocationChanges && kMonitorSignificantLocationChanges) {
        [NotificationManager scheduleSignificantLocationChangesStopLocalNotification];
        
        [self.locationManager stopMonitoringSignificantLocationChanges];
        self.isMonitoringSignificantLocationChanges = NO;
    }
}

- (void)allowDeferredLocationUpdatesUntilTraveled:(CLLocationDistance)distance timeout:(NSTimeInterval)timeout {
    [self.locationManager allowDeferredLocationUpdatesUntilTraveled:distance timeout:timeout];
}

- (void)disallowDeferredLocationUpdates {
    [self.locationManager disallowDeferredLocationUpdates];
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DDLogInfo(@"didChangeAuthorizationStatus: %d", status);
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.isRequestingAuthorization) {
                self.isRequestingAuthorization = NO;
                
                self.isRunning = YES;
                [self startUpdatingLocation];
            }
            else {
                if ([self.delegate respondsToSelector:@selector(didChangeAuthorizationStatus:)]) {
                    [self.delegate didChangeAuthorizationStatus:status];
                }
            }
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            if (self.isRequestingAuthorization) {
                self.isRequestingAuthorization = NO;
            }
            else {
                if ([self.delegate respondsToSelector:@selector(didChangeAuthorizationStatus:)]) {
                    [self.delegate didChangeAuthorizationStatus:status];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DDLogInfo(@"didFailWithError: %@", error);
    
    if (error.code != kCLErrorLocationUnknown) {
        [ErrorManager showAlertForLocationErrorCode:error.code];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFailToFindLocationWithError:)]) {
        [self.delegate didFailToFindLocationWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    DDLogInfo(@"didFinishDeferredUpdatesWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    DDLogInfo(@"didUpdateLocations: %@", locations);
    
    CLLocation *location = [locations lastObject];
    self.lastUpdateDate = location.timestamp;
    
    if (location.horizontalAccuracy < self.accuracyThreshold) {
        if ([self.delegate respondsToSelector:@selector(didUpdateLocation:)]) {
            [self.delegate didUpdateLocation:location];
        }
        
        [self stop];
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    DDLogInfo(@"locationManagerDidPauseLocationUpdates");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    DDLogInfo(@"locationManagerDidResumeLocationUpdates");
}

@end
