//
//  NPRStation+RZImport.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStation.h"

#import <RZImport/NSObject+RZImport.h>
#import <CoreLocation/CLLocation.h>

typedef void(^NPRStationCompletionBlock)(NSArray *stations, NSError *error);

@interface NPRStation (RZImport) <RZImportable>

+ (void)getStationsNearLocation:(CLLocation *)location completion:(NPRStationCompletionBlock)completion;
+ (void)getStationsWithSearchText:(NSString *)searchText completion:(NPRStationCompletionBlock)completion;
+ (NSDictionary *)mockStationJsonWithFrequency:(NSString *)frequency signalStrength:(NSNumber *)signalStrength;

@end
