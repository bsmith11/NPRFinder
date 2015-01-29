//
//  ErrorManager.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTAttributedLabel;

@interface ErrorManager : NSObject

+ (void)showAlertForNetworkError:(NSError *)error;
+ (void)showAlertForLocationErrorCode:(NSInteger)code;

+ (void)setupLabel:(TTTAttributedLabel *)label locationError:(NSError *)error;
+ (void)setupLabel:(TTTAttributedLabel *)label networkError:(NSError *)error;

@end
