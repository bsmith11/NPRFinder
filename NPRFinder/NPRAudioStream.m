//
//  NPRAudioStream.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioStream.h"

@implementation NPRAudioStream

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    NPRAudioStream *audioStream = (NPRAudioStream *)object;
    if ([audioStream.streamGUID isEqualToString:self.streamGUID]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSString *)description {
    NSString *description = [super description];
    
    description = [NSString stringWithFormat:@"%@ {\nURL = %@\nstreamGUID = %@\ntitle = %@\ntypeName = %@\ntype = %@\nprimary = %@\n}", description, self.URL, self.streamGUID, self.title, self.typeName, @(self.type), @(self.isPrimaryStream)];
    
    return description;
}

@end
