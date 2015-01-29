//
//  CrashlyticsLogger.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/18/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "CrashlyticsLogger.h"
#import <Crashlytics/Crashlytics.h>

@implementation CrashlyticsLogger

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *logMsg;
    
    if (self->formatter) {
        logMsg = [self->formatter formatLogMessage:logMessage];
    }
    else {
        logMsg = logMessage->logMsg;
    }
    
    if (logMsg) {
        CLSLog(@"%@", logMsg);
    }
}

@end
