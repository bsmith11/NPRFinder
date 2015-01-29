//
//  NSString+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface NSString (NPRFinder)

+ (NSString *)npr_coordinatesFromLocation:(CLLocation *)location;

@end
