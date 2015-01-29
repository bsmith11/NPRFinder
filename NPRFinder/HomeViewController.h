//
//  HomeViewController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationManager.h"
#import "BaseViewController.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <SSPullToRefresh/SSPullToRefresh.h>

@interface HomeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, LocationManagerDelegate, TTTAttributedLabelDelegate, SSPullToRefreshViewDelegate>

@property (assign, nonatomic) BOOL shouldReloadTable;

@end
