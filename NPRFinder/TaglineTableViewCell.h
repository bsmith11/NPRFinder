//
//  TaglineTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;

@interface TaglineTableViewCell : UITableViewCell

- (void)setupWithStation:(Station *)station;

+ (CGFloat)heightWithStation:(Station *)station;

@end
