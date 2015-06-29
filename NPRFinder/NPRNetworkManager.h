//
//  NPRNetworkManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@class NPRStation;

@interface NPRNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)searchForStationsWithText:(NSString *)text
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getProgramsForStation:(NPRStation *)station
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
