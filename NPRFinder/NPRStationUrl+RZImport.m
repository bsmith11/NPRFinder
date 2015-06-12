//
//  NPRStationUrl+RZImport.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationUrl+RZImport.h"

#import "NPRNetworkConstants.h"

@implementation NPRStationUrl (RZImport)

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
    if ([key isEqualToString:kNPRResponseKeyStationUrlHREF]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.url = [NSURL URLWithString:value];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Mock Object

+ (NSDictionary *)mockStationUrlJSONWithTypeId:(NSNumber *)typeId {
    NSDictionary *json = @{kNPRResponseKeyStationUrlTypeId:typeId,
                           kNPRResponseKeyStationUrlTypeName:@"Organization Home Page",
                           kNPRResponseKeyStationUrlTitle:@"WAMU Homepage",
                           kNPRResponseKeyStationUrlHREF:@"http://wamu.org"};
    
    return json;
}

@end
