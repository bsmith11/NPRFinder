//
//  StationTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;

@interface StationTableViewCell : UITableViewCell

- (void)setupWithStation:(Station *)station;
- (void)hideWithStation:(Station *)station delay:(CGFloat)delay;
- (void)stopAnimation;

+ (CGFloat)heightWithStation:(Station *)station;
+ (CGFloat)estimatedHeight;

@end
