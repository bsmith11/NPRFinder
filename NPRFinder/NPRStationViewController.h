//
//  NPRStationViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

#import "NPRBaseViewController.h"
#import "NPRStationViewModel.h"

@class NPRStation;

@interface NPRStationViewController : NPRBaseViewController

- (instancetype)initWithStationViewModel:(NPRStationViewModel *)stationViewModel
                         backgroundColor:(UIColor *)backgroundColor;

@end
