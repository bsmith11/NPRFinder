//
//  NPRStation.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStation.h"

#import "NPRStationUrl.h"

@interface NPRStation ()

@end

@implementation NPRStation

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    NPRStation *station = (NPRStation *)object;
    if ([station.organizationId integerValue] == [self.organizationId integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSString *)marketLocation {
    return [NSString stringWithFormat:@"%@, %@", self.marketCity, self.marketState];
}

@end
