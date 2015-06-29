//
//  UIView+NPRAutoLayout.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface UIView (NPRAutoLayout)

- (NSArray *)npr_fillSuperview;
- (NSArray *)npr_fillSuperviewWithInsets:(UIEdgeInsets)insets;

- (NSArray *)npr_fillSuperviewHorizontally;
- (NSArray *)npr_fillSuperviewHorizontallyWithPadding:(CGFloat)padding;

- (NSArray *)npr_fillSuperviewVertically;
- (NSArray *)npr_fillSuperviewVerticallyWithPadding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinTopToSuperview;
- (NSLayoutConstraint *)npr_pinTopToSuperviewWithPadding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinBottomToSuperview;
- (NSLayoutConstraint *)npr_pinBottomToSuperviewWithPadding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinLeadingToSuperview;
- (NSLayoutConstraint *)npr_pinLeadingToSuperviewWithPadding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinTrailingToSuperview;
- (NSLayoutConstraint *)npr_pinTrailingToSuperviewWithPadding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_centerHorizontallyInSuperview;
- (NSLayoutConstraint *)npr_centerHorizontallyInSuperviewWithOffset:(CGFloat)offset;

- (NSLayoutConstraint *)npr_centerVerticallyInSuperview;
- (NSLayoutConstraint *)npr_centerVerticallyInSuperviewWithOffset:(CGFloat)offset;

- (NSLayoutConstraint *)npr_centerHorizontallyWithView:(UIView *)view;
- (NSLayoutConstraint *)npr_centerHorizontallyWithView:(UIView *)view offset:(CGFloat)offset;

- (NSLayoutConstraint *)npr_centerVerticallyWithView:(UIView *)view;
- (NSLayoutConstraint *)npr_centerVerticallyWithView:(UIView *)view offset:(CGFloat)offset;

- (NSArray *)npr_pinSize:(CGSize)size;

- (NSLayoutConstraint *)npr_pinWidth:(CGFloat)width;
- (NSLayoutConstraint *)npr_pinHeight:(CGFloat)height;

- (NSLayoutConstraint *)npr_pinTopToView:(UIView *)view;
- (NSLayoutConstraint *)npr_pinTopToView:(UIView *)view padding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinBottomToView:(UIView *)view;
- (NSLayoutConstraint *)npr_pinBottomToView:(UIView *)view padding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinLeadingToView:(UIView *)view;
- (NSLayoutConstraint *)npr_pinLeadingToView:(UIView *)view padding:(CGFloat)padding;

- (NSLayoutConstraint *)npr_pinTrailingToView:(UIView *)view;
- (NSLayoutConstraint *)npr_pinTrailingToView:(UIView *)view padding:(CGFloat)padding;

@end
