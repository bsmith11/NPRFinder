//
//  UITableViewCell+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UITableViewCell+NPRFinder.h"

@implementation UITableViewCell (NPRFinder)

+ (NSString *)npr_reuseIdentifier {
    return NSStringFromClass(self);
}

+ (UINib *)npr_nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

@end
