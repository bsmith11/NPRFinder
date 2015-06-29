//
//  NPRNotificationManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRNotificationManager.h"

#import "NPRSwitchConstants.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation NPRNotificationManager

#pragma mark - Local Notifications

+ (void)scheduleLocalNotificationWithText:(NSString *)text {
    NSString *alertBody = text;
    NSDate *fireDate = [NSDate date];
    
    [NPRNotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                       fireDate:fireDate];
}

+ (void)scheduleLocationUpdatesStartLocalNotification {
    if (kNPRSendLocationUpdatesStartLocalNotification) {
        DDLogInfo(@"Location updates start local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Location Updates Started"];
        NSDate *fireDate = [NSDate date];
        
        [NPRNotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleLocationUpdatesStopLocalNotification {
    if (kNPRSendLocationUpdatesStopLocalNotification) {
        DDLogInfo(@"Location updates stop local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Location Updates Stopped"];
        NSDate *fireDate = [NSDate date];
        
        [NPRNotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleSignificantLocationChangesStartLocalNotification {
    if (kNPRSendSignificantChangesStartLocalNotification) {
        DDLogInfo(@"Significant location changes start local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Significant Location Changes Started"];
        NSDate *fireDate = [NSDate date];
        
        [NPRNotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleSignificantLocationChangesStopLocalNotification {
    if (kNPRSendSignificantChangesStopLocalNotification) {
        DDLogInfo(@"Significant location changes stop local notification scheduled");
        
        NSString *alertBody = [NSString stringWithFormat:@"Significant Location Changes Stopped"];
        NSDate *fireDate = [NSDate date];
        
        [NPRNotificationManager scheduleLocalNotificationWithAlertBody:alertBody
                                                           fireDate:fireDate];
    }
}

+ (void)scheduleLocalNotificationWithAlertBody:(NSString *)alertBody
                                      fireDate:(NSDate *)fireDate {
    if ([NPRNotificationManager areUserNotificationSettingsEnabled]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = fireDate;
        localNotification.alertBody = alertBody;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
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
