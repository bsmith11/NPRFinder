//
//  NSString+NPRUtil.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NSString+NPRUtil.h"

#import <CoreLocation/CLLocation.h>

@implementation NSString (NPRUtil)

+ (NSString *)npr_coordinatesFromLocation:(CLLocation *)location {
    NSNumberFormatter *numberFormatter =  [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = 8;
    numberFormatter.locale = [NSLocale currentLocale];
    
    NSString *latitude = [numberFormatter stringFromNumber:@(location.coordinate.latitude)];
    NSString *longitude = [numberFormatter stringFromNumber:@(location.coordinate.longitude)];
    NSString *coordinates = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    
    return coordinates;
}

@end
