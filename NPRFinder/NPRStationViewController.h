//
//  NPRStationViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRBaseViewController.h"

#import <UIKit/UIKit.h>

@class NPRStation;

@interface NPRStationViewController : NPRBaseViewController

- (instancetype)initWithStation:(NPRStation *)station color:(UIColor *)color;

@end
