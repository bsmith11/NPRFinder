//
//  NetworkManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@class Station;

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - Search

- (void)searchForStationsWithText:(NSString *)text
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getProgramsForStation:(Station *)station
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
