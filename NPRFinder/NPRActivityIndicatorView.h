//
//  NPRActivityIndicatorView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface NPRActivityIndicatorView : UIView

- (void)startAnimating;
- (void)stopAnimating;

@property (strong, nonatomic) UIColor *color;

@property (assign, nonatomic, getter=isAnimating, readonly) BOOL animating;

@end
