//
//  NPRSplashView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRSplashView.h"

#import "UIColor+NPRStyle.h"

@implementation NPRSplashView

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor npr_redColor];
    }

    return self;
}

@end
