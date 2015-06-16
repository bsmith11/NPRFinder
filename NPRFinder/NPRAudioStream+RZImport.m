//
//  NPRAudioStream+RZImport.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioStream+RZImport.h"

#import "NPRNetworkConstants.h"

@implementation NPRAudioStream (RZImport)

#pragma mark - RZImportable

+ (NSDictionary *)rzi_customMappings {
    return nil;
}

+ (NSString *)rzi_dateFormatForKey:(NSString *)key {
    return nil;
}

+ (NSArray *)rzi_ignoredKeys {
    return nil;
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kNPRResponseKeyStationURLHREF]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.URL = [NSURL URLWithString:value];
        }
        
        return NO;
    }
    else if ([key isEqualToString:kNPRResponseKeyStationURLTypeID]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.type = [value integerValue];
        }
        
        return NO;
    }
    
    return YES;
}

@end
