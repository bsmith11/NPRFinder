//
//  StationDetailsTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationDetailsTableViewCell : UITableViewCell

- (void)setupWithText:(NSString *)text count:(NSInteger)count indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)height;

@end
