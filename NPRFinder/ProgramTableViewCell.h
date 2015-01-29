//
//  ProgramTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Program;

@interface ProgramTableViewCell : UITableViewCell

- (void)setupWithProgram:(Program *)program;

+ (CGFloat)height;

@end
