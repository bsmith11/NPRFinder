//
//  NSString+NPRUtil.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface NSString (NPRUtil)

+ (NSString *)npr_coordinatesFromLocation:(CLLocation *)location;

@end
