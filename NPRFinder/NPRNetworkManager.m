//
//  NPRNetworkManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRNetworkManager.h"

#import "NPRPrivateConstants.h"
#import "NPRNetworkConstants.h"
#import "NPRStation+RZImport.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRNetworkManager ()

@property (strong, nonatomic) NSMutableSet *outstandingSearchTasks;

@end

@implementation NPRNetworkManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNPRBaseURL]];
    });
    
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)URL {
    self = [super initWithBaseURL:URL];
    
    if (self) {
        [self setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
    }
    
    return self;
}

- (NSMutableSet *)outstandingSearchTasks {
    if (!_outstandingSearchTasks) {
        _outstandingSearchTasks = [NSMutableSet set];
    }
    
    return _outstandingSearchTasks;
}

#pragma mark - Network Requests

- (void)searchForStationsWithText:(NSString *)text
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *parameters = @{kNPRRequestKeyAPIKey:kNPRStationFinderAPIKey};
    NSString *path = [NSString stringWithFormat:@"%@%@", kNPRRouteStations, text];

    for (NSURLSessionDataTask *task in self.outstandingSearchTasks) {
        [task cancel];
    }
    
    NSURLSessionDataTask *task = [self GET:path
                                parameters:parameters
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       [self.outstandingSearchTasks removeObject:task];
                                       
                                       if (success) {
                                           success(task, responseObject);
                                       }
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       [self.outstandingSearchTasks removeObject:task];
                                       
                                       if (failure) {
                                           failure(task, error);
                                       }
                                   }];
    
    [self.outstandingSearchTasks addObject:task];
}

- (void)getProgramsForStation:(NPRStation *)station
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *requestValueID = [numberFormatter numberFromString:kNPRRequestValueID];
    
    NSDictionary *parameters = @{kNPRRequestKeyAPIKey:kNPRStationFinderAPIKey,
                                 kNPRRequestKeyID:requestValueID,
                                 kNPRRequestKeyOrganizationID:station.organizationID,
                                 kNPRRequestKeyOutput:kNPRRequestValueOutput};
    
    NSString *path = kNPRRouteProgramsList;
    
    [self GET:path
   parameters:parameters
      success:success
      failure:failure];
}

@end
