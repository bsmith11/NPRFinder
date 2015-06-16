//
//  NPRProgram.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRProgram.h"

@implementation NPRProgram

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    NPRProgram *program = (NPRProgram *)object;
    if ([program.programID integerValue] == [self.programID integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

@end
