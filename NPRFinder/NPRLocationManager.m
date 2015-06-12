//
//  NPRLocationManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRLocationManager.h"
#import "NPRErrorManager.h"
#import "NPRNotificationManager.h"
#import "NPRSwitchConstants.h"
#import "NPRStation+RZImport.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <UIKit/UIKit.h>

static NSString * const kIsUpdatingLocationKey = @"npr_is_updating_location";
static NSString * const kIsMonitoringSignificantLocationChangesKey = @"npr_is_monitoring_significant_location_changes";
static NSString * const kLastUpdateDateKey = @"npr_last_update_date";

@interface NPRLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableSet *stations;

@property (copy, nonatomic) NSDate *lastUpdateDate;

@property (assign, nonatomic) BOOL running;
@property (assign, nonatomic) BOOL requestingAuthorization;
@property (assign, nonatomic) BOOL updatingLocation;
@property (assign, nonatomic) BOOL monitoringSignificantLocationChanges;
@property (assign, nonatomic) CGFloat accuracyThreshold;
@property (assign, nonatomic) CGFloat timePassedThreshold;

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
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        
        _running = NO;
        _requestingAuthorization = NO;
        _accuracyThreshold = 150.0f;
        _timePassedThreshold = 5.0f;
        
        _stations = [NSMutableSet set];
        
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

- (NSDate *)lastUpdateDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:kLastUpdateDateKey];
}

- (void)setLastUpdateDate:(NSDate *)lastUpdateDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastUpdateDate forKey:kLastUpdateDateKey];
    [userDefaults synchronize];
}

- (BOOL)isRunning {
    return self.running;
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
        if ([NPRLocationManager locationServicesDetermined]) {
            if ([NPRLocationManager locationServicesEnabled] && [NPRLocationManager locationServicesAuthorized]) {
                self.running = YES;
                
                [self startUpdatingLocation];
            }
            else {
                NSError *error = [NSError errorWithDomain:@"" code:kCLErrorDenied userInfo:nil];
                [self locationManager:self.locationManager didFailWithError:error];
            }
        }
        else {
            self.running = YES;
            
            if (kNPRRequestLocationServicesRequestAlwaysAuthorization) {
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
        self.running = NO;
        
        [self stopUpdatingLocation];
        [self stopMonitoringSignificantLocationChanges];
    }
}

- (void)startUpdatingLocation {
    if (!self.isUpdatingLocation) {
        [NPRNotificationManager scheduleLocationUpdatesStartLocalNotification];
        
        [self stopMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        self.isUpdatingLocation = YES;
    }
}

- (void)stopUpdatingLocation {
    if (self.isUpdatingLocation) {
        [NPRNotificationManager scheduleLocationUpdatesStopLocalNotification];
        
        [self.locationManager stopUpdatingLocation];
        self.isUpdatingLocation = NO;
    }
}

- (void)startMonitoringSignificantLocationChanges {
    if (!self.isMonitoringSignificantLocationChanges && kNPRMonitorSignificantLocationChanges) {
        [NPRNotificationManager scheduleSignificantLocationChangesStartLocalNotification];
        
        [self stopUpdatingLocation];
        [self.locationManager startMonitoringSignificantLocationChanges];
        self.isMonitoringSignificantLocationChanges = YES;
    }
}

- (void)stopMonitoringSignificantLocationChanges {
    if (self.isMonitoringSignificantLocationChanges && kNPRMonitorSignificantLocationChanges) {
        [NPRNotificationManager scheduleSignificantLocationChangesStopLocalNotification];
        
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

#pragma mark - Station Monitoring

- (NSArray *)followedStations {
    return [self.stations allObjects];
}

- (void)followStation:(NPRStation *)station {
    [self.stations addObject:station];
}

- (void)unfollowStation:(NPRStation *)station {
    [self.stations removeObject:station];
}

- (BOOL)isFollowingStation:(NPRStation *)station {
    return [self.stations containsObject:station];
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DDLogInfo(@"didChangeAuthorizationStatus: %d", status);
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.requestingAuthorization) {
                self.requestingAuthorization = NO;
                
                self.running = YES;
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
            if (self.requestingAuthorization) {
                self.requestingAuthorization = NO;
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
        [NPRErrorManager showAlertForLocationErrorCode:error.code];
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
