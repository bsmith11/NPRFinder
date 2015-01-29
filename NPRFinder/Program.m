//
//  Program.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "Program.h"

@implementation Program

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    Program *program = (Program *)object;
    if ([program.programId integerValue] == [self.programId integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [@"programId" hash] ^ [self.programId hash];
}

#pragma mark - JSON Serializing Delegate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"programId":@"id",
             @"title":@"title.$text",
             @"programDescription":@"additionalInfo.$text"};
}

#pragma mark - Mock Objects

+ (NSDictionary *)mockProgramJsonWithTitle:(NSString *)title {
    NSDictionary *json = @{@"additionalInfo" : @{@"$text" : @"test description"},
                           @"id" : @0,
                           @"num": @"0",
                           @"title": @{@"$text" : title},
                           @"type": @"program"};
    
    return json;
}

+ (instancetype)mockProgram {
    NSError *error;
    Program *program = [MTLJSONAdapter modelOfClass:Program.class fromJSONDictionary:[Program mockProgramJsonWithTitle:@"Test Title"] error:&error];
    
    return program;
}

@end
