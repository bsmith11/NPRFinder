//
//  NPRStationUrl.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationUrl.h"

@implementation NPRStationUrl

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    NPRStationUrl *stationUrl = (NPRStationUrl *)object;
    if ([stationUrl.typeId integerValue] == [self.typeId integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

@end
