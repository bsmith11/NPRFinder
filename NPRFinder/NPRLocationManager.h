//
//  NPRLocationManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class NPRStation;

@protocol NPRLocationManagerDelegate <NSObject>

- (void)didUpdateLocation:(CLLocation *)location;
- (void)didFailToFindLocationWithError:(NSError *)error;
- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end

@interface NPRLocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

+ (BOOL)locationServicesEnabled;
+ (BOOL)locationServicesAlwaysAuthorized;
+ (BOOL)locationServicesWhenInUseAuthorized;
+ (BOOL)backgroundAppRefreshEnabled;

- (CLLocation *)location;

- (void)requestAlwaysAuthorization;
- (void)requestWhenInUseAuthorization;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;

- (BOOL)isRunning;
- (BOOL)isUpdatingLocation;
- (BOOL)isMonitoringSignificantLocationChanges;

- (void)start;
- (void)stop;

- (NSArray *)followedStations;
- (void)followStation:(NPRStation *)station;
- (void)unfollowStation:(NPRStation *)station;
- (BOOL)isFollowingStation:(NPRStation *)station;

@property (weak, nonatomic) id <NPRLocationManagerDelegate> delegate;

@end
