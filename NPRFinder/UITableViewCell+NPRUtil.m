//
//  UITableViewCell+NPRUtil.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UITableViewCell+NPRUtil.h"

@implementation UITableViewCell (NPRUtil)

+ (UINib *)npr_nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (NSString *)npr_reuseIdentifier {
    return NSStringFromClass(self);
}

@end
