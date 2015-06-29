//
//  NPREmptyListView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/16/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPREmptyListView.h"

#import "UIFont+NPRStyle.h"
#import "UIColor+NPRStyle.h"
#import "UIScreen+NPRUtil.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAutoLayout.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

@interface NPREmptyListView ()

@property (strong, nonatomic) UILabel *emptyListLabel;
@property (strong, nonatomic) UIButton *actionButton;

@property (copy, nonatomic) NSString *emptyListText;
@property (copy, nonatomic) NSString *actionText;

@end

@implementation NPREmptyListView

#pragma mark - Lifecycle

- (instancetype)initWithEmptyListText:(NSString *)emptyListText
                           actionText:(NSString *)actionText
                          actionBlock:(void (^)())actionBlock {
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _emptyListText = emptyListText;
        _actionText = actionText;
        _actionBlock = actionBlock;
        
        [self setupEmptyListLabel];
        [self setupActionButton];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupEmptyListLabel {
    self.emptyListLabel = [[UILabel alloc] init];
    self.emptyListLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.emptyListLabel];

    [self.emptyListLabel npr_fillSuperviewHorizontally];
    [self.emptyListLabel npr_pinTopToSuperview];

    self.emptyListLabel.backgroundColor = [UIColor clearColor];
    self.emptyListLabel.textColor = [UIColor npr_foregroundColor];
    self.emptyListLabel.font = [UIFont npr_homeEmptyListFont];
    self.emptyListLabel.numberOfLines = 0;
    self.emptyListLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyListLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyListLabel.text = self.emptyListText;
}

- (void)setupActionButton {
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.actionButton];

    [self.actionButton npr_centerHorizontallyInSuperview];
    [self.actionButton npr_pinBottomToSuperview];
    [self.actionButton npr_pinTopToView:self.emptyListLabel padding:kNPRPadding];

    self.actionButton.backgroundColor = [UIColor clearColor];
    [self.actionButton setTitleColor:[UIColor npr_foregroundColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont npr_homeEmptyListFont];
    self.actionButton.titleLabel.numberOfLines = 0;
    self.actionButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.actionButton setTitle:self.actionText forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(actionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)actionButtonTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - Animations

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    CGFloat value = 0.0f;
    
    [self animateValue:value animated:animated completion:completion];
}

- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    CGFloat value = -[UIScreen npr_screenWidth];
    
    [self animateValue:value animated:animated completion:completion];
}

- (void)animateValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [NSObject pop_animate:^{
            self.layer.pop_spring.pop_translationX = value;
        } completion:completion];
    }
    else {
        CATransform3D transform = CATransform3DMakeTranslation(value, 0.0f, 0.0f);
        self.layer.transform = transform;
        
        if (completion) {
            completion(YES);
        }
    }
}

@end
