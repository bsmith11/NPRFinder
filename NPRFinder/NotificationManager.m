//
//  NotificationManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NotificationManager.h"
#import "SwitchConstants.h"
#import "Station.h"

@implementation NotificationManager

#pragma mark - Local Notifications

+ (void)scheduleStationLocalNotificationWithStation:(Station *)station {
    NSString *alertBody = [NSString stringWithFormat:@"Try %@ %@", station.call, station.frequency];
    NSDate *fireDate = [NSDate date];
    
    [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                       fireDate:fireDate];
}

+ (void)scheduleLocalNotificationWithText:(NSString *)text {
    NSString *alertBody = text;
    NSDate *fireDate = [NSDate date];
    
    [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                       fireDate:fireDate];
}

+ (void)scheduleLocationUpdatesStartLocalNotification {
    if (kSendLocationUpdatesStartLocalNotification) {
        DDLogInfo(@"Location updates start local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Location Updates Started"];
        NSDate *fireDate = [NSDate date];
        
        [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleLocationUpdatesStopLocalNotification {
    if (kSendLocationUpdatesStopLocalNotification) {
        DDLogInfo(@"Location updates stop local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Location Updates Stopped"];
        NSDate *fireDate = [NSDate date];
        
        [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleSignificantLocationChangesStartLocalNotification {
    if (kSendSignificantChangesStartLocalNotification) {
        DDLogInfo(@"Significant location changes start local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Significant Location Changes Started"];
        NSDate *fireDate = [NSDate date];
        
        [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleSignificantLocationChangesStopLocalNotification {
    if (kSendSignificantChangesStopLocalNotification) {
        DDLogInfo(@"Significant location changes stop local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Significant Location Changes Stopped"];
        NSDate *fireDate = [NSDate date];
        
        [NotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleLocalNotificationWithAlertBody:(NSString *)alertBody
                                      fireDate:(NSDate *)fireDate {
    if ([NotificationManager areUserNotificationSettingsEnabled]) {
        UILocalNotification *localNotification = [UILocalNotification new];
        [localNotification setFireDate:fireDate];
        [localNotification setAlertBody:alertBody];
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

+ (BOOL)areUserNotificationSettingsEnabled {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
        
        return (settings.types == (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge));
    }
    else {
        return YES;
    }
}

@end
