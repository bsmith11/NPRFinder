//
//  NetworkManager.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NetworkManager.h"
#import "PrivateConstants.h"
#import "Station.h"

static NSString * const kBaseUrl = @"http://api.npr.org/";

static NSString * const kPathStationQuery = @"v2/stations/";
static NSString * const kPathStationPrograms = @"/list";

static NSString * const kKeyApiKey = @"apiKey";

@interface NetworkManager ()

@property (copy, nonatomic) NSMutableSet *activeTasks;

@end

@implementation NetworkManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    });
    
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        _activeTasks = [NSMutableSet set];
    }
    
    return self;
}

#pragma mark - Search

- (void)searchForStationsWithText:(NSString *)text
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *parameters = @{kKeyApiKey:kStationFinderApiKey};
    NSString *path = [NSString stringWithFormat:@"%@%@", kPathStationQuery, text];
    
    [self cancelRequestsWithMethod:@"GET"
                              path:path];
    
    [self GET:path
   parameters:parameters
      success:success
      failure:failure];
}

#pragma mark - Station Programs

- (void)getProgramsForStation:(Station *)station
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *parameters = @{kKeyApiKey:kStationFinderApiKey,
                                 @"id":@3004,
                                 @"orgId":station.organizationId,
                                 @"output":@"JSON"};
    
    NSString *path = kPathStationPrograms;
    
    [self GET:path
   parameters:parameters
      success:success
      failure:failure];
}

#pragma mark - Request Cancel

- (void)cancelRequestsWithMethod:(NSString *)method path:(NSString *)path {
    NSString *url = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    
    for (NSURLSessionDataTask *task in [self dataTasks]) {
        if ([task.originalRequest.HTTPMethod isEqualToString:method] &&
            [[task.originalRequest.URL absoluteString] isEqualToString:url]) {
            [task cancel];
            
            DDLogInfo(@"Cancelled task: %@ %@", method, path);
        }
    }
}

@end
