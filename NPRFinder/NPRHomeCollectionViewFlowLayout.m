//
//  NPRHomeCollectionViewFlowLayout.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRHomeCollectionViewFlowLayout.h"

#import "UIScreen+NPRUtil.h"

static const CGFloat kNPRHomeMinimumInteritemSpacing = 0.0f;
static const CGFloat kNPRHomeMinimumLineSpacing = 0.0f;
static const CGFloat kNPRHomeStationCellHeight = 150.0f;

@interface NPRHomeCollectionViewFlowLayout ()

@property (strong, nonatomic) NSMutableArray *indexPathsToAnimate;

@end

@implementation NPRHomeCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumInteritemSpacing = kNPRHomeMinimumInteritemSpacing;
        self.minimumLineSpacing = kNPRHomeMinimumLineSpacing;
        self.itemSize = CGSizeMake([UIScreen npr_screenWidth], kNPRHomeStationCellHeight);
    }
    
    return self;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([self.indexPathsToAnimate containsObject:itemIndexPath]) {
        attributes.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.collectionView.frame), 0.0f);
        
        [self.indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([self.indexPathsToAnimate containsObject:itemIndexPath]) {
        attributes.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.collectionView.frame), 0.0f);
        
        [self.indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    
    return !CGSizeEqualToSize(oldBounds.size, newBounds.size);
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
                
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
                
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
                
            default:
                //no-op
                break;
        }
    }
    
    self.indexPathsToAnimate = indexPaths;
}

@end
