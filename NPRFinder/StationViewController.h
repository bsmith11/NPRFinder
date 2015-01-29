//
//  StationViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StationUrlTableViewCell.h"

@class Station;

@interface StationViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, StationUrlTableViewCellDelegate>

- (instancetype)initWithStation:(Station *)station;
- (instancetype)initWithStation:(Station *)station backgroundImage:(UIImage *)backgroundImage;

@end
