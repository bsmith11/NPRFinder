//
//  UITableView+NPRFinder.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRTableViewStyle) {
    NPRTableViewStyleStation,
    NPRTableViewStyleStationDetails,
    NPRTableViewStyleProgram
};

@interface UITableView (NPRFinder)

- (void)npr_setupWithStyle:(NPRTableViewStyle)style
                  delegate:(id<UITableViewDelegate>)delegate
                dataSource:(id<UITableViewDataSource>)dataSource;

@end
