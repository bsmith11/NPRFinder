//
//  NPRHomeViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"
#import "NPRHomeViewModel.h"

@interface NPRHomeViewController : NPRBaseViewController

- (instancetype)initWithHomeViewModel:(NPRHomeViewModel *)homeViewModel clearBackground:(BOOL)clearBackground;

@end
