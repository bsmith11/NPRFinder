//
//  NPRProgram.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPRProgram : NSObject

@property (copy, nonatomic) NSNumber *programId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *programDescription;

@end
