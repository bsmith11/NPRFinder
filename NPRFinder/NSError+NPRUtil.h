//
//  NSError+NPRUtil.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/3/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * const kNPRErrorTextKey;
OBJC_EXTERN NSString * const kNPRErrorActionKey;

@interface NSError (NPRUtil)

+ (NSError *)npr_permissionError;
+ (NSError *)npr_locationErrorFromCode:(NSInteger)code;
+ (NSError *)npr_networkErrorFromError:(NSError *)error;
+ (NSError *)npr_noResultsError;

@end
