//
//  NPRProgram+RZImport.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRProgram+RZImport.h"

#import "NPRSwitchConstants.h"
#import "NPRNetworkConstants.h"
#import "NPRNetworkManager.h"
#import "NPRStation+RZImport.h"

#import <RZDataBinding/RZDBMacros.h>

static const NSInteger kNPRMockProgramCount = 5;

@implementation NPRProgram (RZImport)

#pragma mark - RZImportable

+ (NSDictionary *)rzi_customMappings {
    return @{kNPRResponseKeyProgramId:@"programId"};
}

+ (NSString *)rzi_dateFormatForKey:(NSString *)key {
    return nil;
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kNPRResponseKeyProgramNum, kNPRResponseKeyProgramType];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kNPRResponseKeyProgramTitle]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.title = value[kNPRResponseKeyProgramText];
        }
        
        return NO;
    }
    else if ([key isEqualToString:kNPRResponseKeyProgramAdditionalInfo]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.programDescription = value[kNPRResponseKeyProgramText];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Network Requests

+ (void)getProgramsForStation:(NPRStation *)station completion:(NPRProgramCompletionBlock)completion {
    if (kNPRUseMockStationObjects) {
        NSMutableArray *responseArray = [NSMutableArray array];
        for (NSInteger i = 0; i < kNPRMockProgramCount; i++) {
            [responseArray addObject:[NPRProgram mockProgramJsonWithTitle:@"test program"]];
        }
        
        NSDictionary *responseObject = @{kNPRResponseKeyProgramItem:[responseArray copy]};
        
        [self handleSuccessfulProgramRequestWithResponseObject:responseObject completion:completion];
    }
    else {
        [[NPRNetworkManager sharedManager] getProgramsForStation:station
                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                          [NPRProgram handleSuccessfulProgramRequestWithResponseObject:responseObject completion:completion];
                                                      }
                                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          [NPRProgram handleFailedProgramRequestWithError:error completion:completion];
                                                      }];
    }
}

#pragma mark - Network Response Handlers

+ (void)handleSuccessfulProgramRequestWithResponseObject:(id)responseObject completion:(NPRProgramCompletionBlock)completion {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *responseArray = responseDictionary[kNPRResponseKeyProgramItem];
        NSArray *programs = [NPRProgram rzi_objectsFromArray:responseArray];
        
        if (completion) {
            completion(programs, nil);
        }
    }
    else {
        NSError *error = [NSError errorWithDomain:@"npr_bad_response_object" code:0 userInfo:nil];
        
        if (completion) {
            completion(nil, error);
        }
    }
}

+ (void)handleFailedProgramRequestWithError:(NSError *)error completion:(NPRProgramCompletionBlock)completion {
    if (completion) {
        completion(nil, error);
    }
}

#pragma mark - Mock Object

+ (NSDictionary *)mockProgramJsonWithTitle:(NSString *)title {
    NSDictionary *json = @{kNPRResponseKeyProgramAdditionalInfo:@{kNPRResponseKeyProgramText:@"test description"},
                           kNPRResponseKeyProgramId:@0,
                           kNPRResponseKeyProgramNum:@"0",
                           kNPRResponseKeyProgramTitle:@{kNPRResponseKeyProgramText:title},
                           kNPRResponseKeyProgramType:@"program"};
    
    return json;
}

@end
