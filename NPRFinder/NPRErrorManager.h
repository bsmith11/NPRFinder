//
//  NPRErrorManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

@interface NPRErrorManager : NSObject

+ (void)showAlertForNetworkError:(NSError *)error;
+ (void)showAlertForLocationErrorCode:(NSInteger)code;

@end
