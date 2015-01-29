//
//  LocationManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

- (void)didUpdateLocation:(CLLocation *)location;
- (void)didFailToFindLocationWithError:(NSError *)error;
- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

+ (BOOL)locationServicesEnabled;
+ (BOOL)locationServicesAuthorized;
+ (BOOL)backgroundAppRefreshEnabled;

- (CLLocation *)location;

- (void)requestAlwaysAuthorization;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;

- (BOOL)isRunning;
- (BOOL)isUpdatingLocation;
- (BOOL)isMonitoringSignificantLocationChanges;

- (void)start;
- (void)stop;

@property (weak, nonatomic) id <LocationManagerDelegate> delegate;

@end
