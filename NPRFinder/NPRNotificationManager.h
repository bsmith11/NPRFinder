//
//  NPRNotificationManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NPRStation;

@interface NPRNotificationManager : NSObject

+ (void)scheduleStationLocalNotificationWithStation:(NPRStation *)station;

+ (void)scheduleLocalNotificationWithText:(NSString *)text;
+ (void)scheduleLocationUpdatesStartLocalNotification;
+ (void)scheduleLocationUpdatesStopLocalNotification;
+ (void)scheduleSignificantLocationChangesStartLocalNotification;
+ (void)scheduleSignificantLocationChangesStopLocalNotification;
+ (void)scheduleLocalNotificationWithAlertBody:(NSString *)alertBody
                                      fireDate:(NSDate *)fireDate;
+ (BOOL)areUserNotificationSettingsEnabled;

@end
