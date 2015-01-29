//
//  UITableView+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UITableView+NPRFinder.h"
#import "StationTableViewCell.h"
#import "TaglineTableViewCell.h"
#import "UITableViewCell+NPRFinder.h"
#import "StationUrlTableViewCell.h"
#import "ProgramTableViewCell.h"
#import "StationDetailsTableViewCell.h"

@implementation UITableView (NPRFinder)

- (void)npr_setupWithStyle:(NPRTableViewStyle)style
                  delegate:(id<UITableViewDelegate>)delegate
                dataSource:(id<UITableViewDataSource>)dataSource {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self setDelegate:delegate];
    [self setDataSource:dataSource];
    
    switch (style) {
        case NPRTableViewStyleStation:
            [self registerNib:[StationTableViewCell npr_nib] forCellReuseIdentifier:[StationTableViewCell npr_reuseIdentifier]];
            break;
            
        case NPRTableViewStyleStationDetails:
            [self registerNib:[TaglineTableViewCell npr_nib] forCellReuseIdentifier:[TaglineTableViewCell npr_reuseIdentifier]];
            [self registerNib:[StationUrlTableViewCell npr_nib] forCellReuseIdentifier:[StationUrlTableViewCell npr_reuseIdentifier]];
            [self registerNib:[StationDetailsTableViewCell npr_nib] forCellReuseIdentifier:[StationDetailsTableViewCell npr_reuseIdentifier]];
            break;
            
        case NPRTableViewStyleProgram:
            [self registerNib:[ProgramTableViewCell npr_nib] forCellReuseIdentifier:[ProgramTableViewCell npr_reuseIdentifier]];
            break;
            
        default:
            break;
    }
}

@end
