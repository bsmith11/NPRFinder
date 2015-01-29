//
//  NSString+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NSString+NPRFinder.h"

#import <CoreLocation/CoreLocation.h>

@implementation NSString (NPRFinder)

+ (NSString *)npr_coordinatesFromLocation:(CLLocation *)location {
    NSNumberFormatter *numberFormatter =  [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *latitude = [numberFormatter stringFromNumber:@(location.coordinate.latitude)];
    NSString *longitude = [numberFormatter stringFromNumber:@(location.coordinate.longitude)];
    NSString *coordinates = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    
    return coordinates;
}

@end
