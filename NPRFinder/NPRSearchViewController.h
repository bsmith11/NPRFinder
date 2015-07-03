//
//  NPRSearchViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"
#import "NPRSearchViewModel.h"

@interface NPRSearchViewController : NPRBaseViewController

- (instancetype)initWithSearchViewModel:(NPRSearchViewModel *)searchViewModel;

@end
