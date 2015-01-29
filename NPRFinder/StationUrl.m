//
//  StationUrl.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "StationUrl.h"

@implementation StationUrl

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    StationUrl *stationUrl = (StationUrl *)object;
    if ([stationUrl.typeId integerValue] == [self.typeId integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [@"typeId" hash] ^ [self.typeId hash];
}

#pragma mark - JSON Serializing Delegate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"typeId":@"type_id",
             @"typeName":@"type_name",
             @"title":@"title",
             @"url":@"href"};
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)typeIdJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *stringValue) {
        return @([stringValue integerValue]);
    } reverseBlock:^(NSNumber *numberValue) {
        return [numberValue stringValue];
    }];
}

@end
