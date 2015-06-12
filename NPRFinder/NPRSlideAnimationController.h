//
//  NPRSlideAnimationController.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPRSlideAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) NSIndexPath *selectedIndexPath;

@property (assign, nonatomic, getter=isPositive) BOOL positive;

@end
