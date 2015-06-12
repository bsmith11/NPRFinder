//
//  NPRProgram+RZImport.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRProgram.h"

#import "NPRStation+RZImport.h"

#import <RZImport/NSObject+RZImport.h>

typedef void(^NPRProgramCompletionBlock)(NSArray *programs, NSError *error);

@interface NPRProgram (RZImport) <RZImportable>

+ (void)getProgramsForStation:(NPRStation *)station completion:(NPRProgramCompletionBlock)completion;
+ (NSDictionary *)mockProgramJsonWithTitle:(NSString *)title;

@end
