//
//  DetailAnimationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/9/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailDirection) {
    DetailDirectionIn,
    DetailDirectionOut
};

@interface DetailAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) DetailDirection detailDirection;
@property (assign, nonatomic) CGRect contentRect;
@property (strong, nonatomic) UITableView *tableView;

@end
