//
//  ProgramsViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface ProgramsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithPrograms:(NSArray *)programs;

@end
