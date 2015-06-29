//
//  UIView+NPRAutoLayout.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIView+NPRAutoLayout.h"

@implementation UIView (NPRAutoLayout)

- (NSArray *)npr_fillSuperview {
    return [self npr_fillSuperviewWithInsets:UIEdgeInsetsZero];
}

- (NSArray *)npr_fillSuperviewWithInsets:(UIEdgeInsets)insets {
    NSLayoutConstraint *top = [self npr_pinTopToSuperviewWithPadding:insets.top];
    NSLayoutConstraint *bottom = [self npr_pinBottomToSuperviewWithPadding:insets.bottom];
    NSLayoutConstraint *leading = [self npr_pinLeadingToSuperviewWithPadding:insets.left];
    NSLayoutConstraint *trailing = [self npr_pinTrailingToSuperviewWithPadding:insets.right];

    return @[top, bottom, leading, trailing];
}

- (NSArray *)npr_fillSuperviewHorizontally {
    return [self npr_fillSuperviewHorizontallyWithPadding:0.0f];
}

- (NSArray *)npr_fillSuperviewHorizontallyWithPadding:(CGFloat)padding {
    NSLayoutConstraint *leading = [self npr_pinLeadingToSuperviewWithPadding:padding];
    NSLayoutConstraint *trailing = [self npr_pinTrailingToSuperviewWithPadding:padding];

    return @[leading, trailing];
}

- (NSArray *)npr_fillSuperviewVertically {
    return [self npr_fillSuperviewVerticallyWithPadding:0.0f];
}

- (NSArray *)npr_fillSuperviewVerticallyWithPadding:(CGFloat)padding {
    NSLayoutConstraint *top = [self npr_pinTopToSuperviewWithPadding:padding];
    NSLayoutConstraint *bottom = [self npr_pinBottomToSuperviewWithPadding:padding];

    return @[top, bottom];
}

- (NSLayoutConstraint *)npr_pinTopToSuperview {
    return [self npr_pinTopToSuperviewWithPadding:0.0f];
}

- (NSLayoutConstraint *)npr_pinTopToSuperviewWithPadding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinBottomToSuperview {
    return [self npr_pinBottomToSuperviewWithPadding:0.0f];
}

- (NSLayoutConstraint *)npr_pinBottomToSuperviewWithPadding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinLeadingToSuperview {
    return [self npr_pinLeadingToSuperviewWithPadding:0.0f];
}

- (NSLayoutConstraint *)npr_pinLeadingToSuperviewWithPadding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinTrailingToSuperview {
    return [self npr_pinTrailingToSuperviewWithPadding:0.0f];
}

- (NSLayoutConstraint *)npr_pinTrailingToSuperviewWithPadding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_centerHorizontallyInSuperview {
    return [self npr_centerHorizontallyInSuperviewWithOffset:0.0f];
}

- (NSLayoutConstraint *)npr_centerHorizontallyInSuperviewWithOffset:(CGFloat)offset {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:offset];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_centerVerticallyInSuperview {
    return [self npr_centerVerticallyInSuperviewWithOffset:0.0f];
}

- (NSLayoutConstraint *)npr_centerVerticallyInSuperviewWithOffset:(CGFloat)offset {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:offset];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_centerHorizontallyWithView:(UIView *)view {
    return [self npr_centerHorizontallyWithView:view offset:0.0f];
}

- (NSLayoutConstraint *)npr_centerHorizontallyWithView:(UIView *)view offset:(CGFloat)offset {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:offset];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_centerVerticallyWithView:(UIView *)view {
    return [self npr_centerVerticallyWithView:view offset:0.0f];
}

- (NSLayoutConstraint *)npr_centerVerticallyWithView:(UIView *)view offset:(CGFloat)offset {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:offset];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSArray *)npr_pinSize:(CGSize)size {
    NSLayoutConstraint *widthConstraint = [self npr_pinWidth:size.width];
    NSLayoutConstraint *heightConstraint = [self npr_pinHeight:size.height];

    return @[widthConstraint, heightConstraint];
}

- (NSLayoutConstraint *)npr_pinWidth:(CGFloat)width {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:width];
    [self addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinHeight:(CGFloat)height {
    NSAssert(self.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    [self addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinTopToView:(UIView *)view {
    return [self npr_pinTopToView:view padding:0.0f];
}

- (NSLayoutConstraint *)npr_pinTopToView:(UIView *)view padding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinBottomToView:(UIView *)view {
    return [self npr_pinBottomToView:view padding:0.0f];
}

- (NSLayoutConstraint *)npr_pinBottomToView:(UIView *)view padding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinLeadingToView:(UIView *)view {
    return [self npr_pinLeadingToView:view padding:0.0f];
}

- (NSLayoutConstraint *)npr_pinLeadingToView:(UIView *)view padding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)npr_pinTrailingToView:(UIView *)view {
    return [self npr_pinTrailingToView:view padding:0.0f];
}

- (NSLayoutConstraint *)npr_pinTrailingToView:(UIView *)view padding:(CGFloat)padding {
    NSAssert(self.superview != nil, @"Must have superview");
    NSAssert(view.superview != nil, @"Must have superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:padding];
    [self.superview addConstraint:constraint];

    return constraint;
}

@end
