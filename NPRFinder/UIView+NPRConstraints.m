//
//  UIView+NPRConstraints.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/14/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UIView+NPRConstraints.h"

@implementation UIView (NPRConstraints)

- (NSLayoutConstraint *)leadingConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)topConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)trailingConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)bottomConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)leadingConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)topConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)trailingConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)bottomConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)heightConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ((UIView *)constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
            return constraint;
        }
    }
    
    return nil;
}

- (NSLayoutConstraint *)widthConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ((UIView *)constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
            return constraint;
        }
    }
    
    return nil;
}

//- (NSLayoutConstraint *)leadingAlignConstraintWithView:(UIView *)view {
//    return [self constraintWithItem:view attribute:NSLayoutAttributeLeading];
//}
//
//- (NSLayoutConstraint *)trailingAlignConstraintWithView:(UIView *)view {
//    return [self constraintWithItem:view attribute:NSLayoutAttributeTrailing];
//}
//
//- (NSLayoutConstraint *)topAlignConstraintWithView:(UIView *)view {
//    return [self constraintWithItem:view attribute:NSLayoutAttribute];
//}
//
//- (NSLayoutConstraint *)bottomAlignConstraintWithView:(UIView *)view {
//    return [self constraintWithItem:view attribute:NSLayoutAttributeBottom];
//}

- (NSLayoutConstraint *)horizontalCenterAlignConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)verticalCenterAlignConstraintWithView:(UIView *)view {
    return [self constraintWithItem:view attribute:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)horizontalCenterAlignConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)verticalCenterAlignConstraintWithSuperview {
    return [self constraintWithItem:self.superview attribute:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)constraintWithItem:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ((UIView *)constraint.secondItem == view && constraint.secondAttribute == attribute) {
            return constraint;
        }
    }
    
    return nil;
}

#pragma mark - Constraint Generation

- (NSLayoutConstraint *)addTopConstraintToSuperviewWithConstant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addTopConstraintToSuperview {
    return [self addTopConstraintToSuperviewWithConstant:0];
}

- (NSLayoutConstraint *)addLeadingConstraintToSuperviewWithConstant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addLeadingConstraintToSuperview {
    return [self addLeadingConstraintToSuperviewWithConstant:0];
}

- (NSLayoutConstraint *)addTrailingConstraintToSuperviewWithConstant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addTrailingConstraintToSuperview {
    return [self addTrailingConstraintToSuperviewWithConstant:0];
}

- (NSLayoutConstraint *)addBottomConstraintToSuperviewWithConstant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addBottomConstraintToSuperview {
    return [self addBottomConstraintToSuperviewWithConstant:0];
}

- (NSLayoutConstraint *)addBottomConstraintToView:(UIView *)view constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addBottomConstraintToView:(UIView *)view {
    return [self addBottomConstraintToView:view constant:0];
}

- (NSLayoutConstraint *)addHeightConstraintWithHeight:(CGFloat)height {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [self addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addWidthConstraintWithWidth:(CGFloat)width {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    
    [self addConstraint:constraint];
    
    return constraint;
}

#pragma mark - Constraint Removal

- (void)removeConstraintsForSubview:(UIView *)subview {
    if (self == subview.superview) {
        NSMutableArray *constraintsToRemove = [NSMutableArray array];
        
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.secondItem == subview) {
                [constraintsToRemove addObject:constraint];
            }
        }
        
        [self removeConstraints:constraintsToRemove];
    }
}

@end
