//
//  NPRUserDefaults.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/29/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRUserDefaults.h"

static NSString *kNPRLocationServicesPermissionResponseKey = @"npr_location_services_permission_response_key";

@implementation NPRUserDefaults

+ (BOOL)locationServicesPermissionResponse {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNPRLocationServicesPermissionResponseKey];
}

+ (void)setLocationServicesPermissionResponse:(BOOL)response {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:response forKey:kNPRLocationServicesPermissionResponseKey];
    [userDefaults synchronize];
}

@end
