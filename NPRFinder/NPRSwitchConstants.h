//
//  NPRSwitchConstants.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, NPRPermissionType) {
    NPRPermissionTypeLocationAlways,
    NPRPermissionTypeLocationWhenInUse
};

OBJC_EXTERN const NPRPermissionType kNPRPermissionType;

OBJC_EXTERN const BOOL kNPRUseMockStationObjects;

OBJC_EXTERN const BOOL kNPRSendLocationUpdatesStartLocalNotification;
OBJC_EXTERN const BOOL kNPRSendLocationUpdatesStopLocalNotification;
OBJC_EXTERN const BOOL kNPRSendSignificantChangesStartLocalNotification;
OBJC_EXTERN const BOOL kNPRSendSignificantChangesStopLocalNotification;

OBJC_EXTERN const BOOL kNPRMonitorSignificantLocationChanges;
