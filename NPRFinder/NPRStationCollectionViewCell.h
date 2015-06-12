//
//  NPRStationCollectionViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPRStation;

@interface NPRStationCollectionViewCell : UICollectionViewCell

- (void)setupWithStation:(NPRStation *)station;

+ (CGSize)sizeWithStation:(NPRStation *)station width:(CGFloat)width;

@end
