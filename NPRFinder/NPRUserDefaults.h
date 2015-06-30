//
//  NPRUserDefaults.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/29/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

@interface NPRUserDefaults : NSObject

+ (BOOL)locationServicesPermissionResponse;
+ (void)setLocationServicesPermissionResponse:(BOOL)response;

@end
