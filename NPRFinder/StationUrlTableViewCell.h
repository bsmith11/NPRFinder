//
//  StationUrlTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;

@protocol StationUrlTableViewCellDelegate <NSObject>

- (void)facebookButtonPressed;
- (void)twitterButtonPressed;
- (void)homePageButtonPressed;

@end

@interface StationUrlTableViewCell : UITableViewCell

- (void)setupWithStation:(Station *)station;

+ (CGFloat)height;

@property (weak, nonatomic) id <StationUrlTableViewCellDelegate> delegate;

@end
