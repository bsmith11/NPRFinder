//
//  UIView+NPRConstraints.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/14/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NPRConstraints)

- (NSLayoutConstraint *)leadingConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)topConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)trailingConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)bottomConstraintWithView:(UIView *)view;

- (NSLayoutConstraint *)leadingConstraintWithSuperview;
- (NSLayoutConstraint *)topConstraintWithSuperview;
- (NSLayoutConstraint *)trailingConstraintWithSuperview;
- (NSLayoutConstraint *)bottomConstraintWithSuperview;

- (NSLayoutConstraint *)heightConstraint;
- (NSLayoutConstraint *)widthConstraint;

- (NSLayoutConstraint *)leadingAlignConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)topAlignConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)trailingAlignConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)bottomAlignConstraintWithView:(UIView *)view;

- (NSLayoutConstraint *)leadingAlignConstraintWithSuperview;
- (NSLayoutConstraint *)topAlignConstraintWithSuperview;
- (NSLayoutConstraint *)trailingAlignConstraintWithSuperview;
- (NSLayoutConstraint *)bottomAlignConstraintWithSuperview;

- (NSLayoutConstraint *)horizontalCenterAlignConstraintWithView:(UIView *)view;
- (NSLayoutConstraint *)verticalCenterAlignConstraintWithView:(UIView *)view;

- (NSLayoutConstraint *)horizontalCenterAlignConstraintWithSuperview;
- (NSLayoutConstraint *)verticalCenterAlignConstraintWithSuperview;

// Constraint Generation
- (NSLayoutConstraint *)addLeadingConstraintToSuperviewWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)addLeadingConstraintToSuperview;
- (NSLayoutConstraint *)addTopConstraintToSuperviewWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)addTopConstraintToSuperview;
- (NSLayoutConstraint *)addTrailingConstraintToSuperviewWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)addTrailingConstraintToSuperview;
- (NSLayoutConstraint *)addBottomConstraintToSuperviewWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)addBottomConstraintToSuperview;

- (NSLayoutConstraint *)addLeadingConstraintToView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)addLeadingConstraintToView:(UIView *)view;
- (NSLayoutConstraint *)addTopConstraintToView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)addTopConstraintToView:(UIView *)view;
- (NSLayoutConstraint *)addTrailingConstraintToView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)addTrailingConstraintToView:(UIView *)view;
- (NSLayoutConstraint *)addBottomConstraintToView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)addBottomConstraintToView:(UIView *)view;

- (NSLayoutConstraint *)addHeightConstraintWithHeight:(CGFloat)height;
- (NSLayoutConstraint *)addWidthConstraintWithWidth:(CGFloat)width;

//Constraint Removal
- (void)removeConstraintsForSubview:(UIView *)subview;

@end
