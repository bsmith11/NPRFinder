//
//  UICollectionReusableView+NPRUtil.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface UICollectionReusableView (NPRUtil)

+ (UINib *)npr_nib;
+ (NSString *)npr_reuseIdentifier;

@end
