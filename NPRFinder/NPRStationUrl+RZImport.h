//
//  NPRStationUrl+RZImport.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationUrl.h"

#import <RZImport/NSObject+RZImport.h>

@interface NPRStationUrl (RZImport) <RZImportable>

+ (NSDictionary *)mockStationUrlJSONWithTypeId:(NSNumber *)typeId;

@end
