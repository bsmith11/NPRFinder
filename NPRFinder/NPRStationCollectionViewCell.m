//
//  NPRStationCollectionViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationCollectionViewCell.h"

#import "UIColor+NPRStyle.h"

@implementation NPRStationCollectionViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    NSIndexPath *indexPath = layoutAttributes.indexPath;
    UIColor *color;
    if (indexPath.row % 3 == 0) {
        color = [UIColor npr_redColor];
    }
    else if (indexPath.row % 3 == 1) {
        color = [UIColor npr_blackColor];
    }
    else {
        color = [UIColor npr_blueColor];
    }
    
    self.backgroundColor = color;
}

#pragma mark - Setup

- (void)setupWithStation:(NPRStation *)station {
    
}

#pragma mark - Size

+ (CGSize)sizeWithStation:(NPRStation *)station width:(CGFloat)width {
    return CGSizeZero;
}

@end
