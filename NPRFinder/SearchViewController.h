//
//  SearchViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage;

@end
