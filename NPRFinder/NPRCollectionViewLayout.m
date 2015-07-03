//
//  NPRCollectionViewLayout.m
//  NPRFinder
//
//  Created by Bradley Smith on 7/3/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRCollectionViewLayout.h"

#import "NPRStationCell.h"

@implementation NPRCollectionViewLayout

- (instancetype)init {
    self = [super init];

    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumInteritemSpacing = 0.0f;
        self.minimumLineSpacing = 0.0f;
    }

    return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    self.itemSize = [NPRStationCell sizeWithWidth:width];
}

@end
