//
//  NPRActivityIndicatorView.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRActivityIndicatorView.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

static const CGFloat kNPRActivityIndicatorViewItemWidth = 16.0f;
static const CGFloat kNPRActivityIndicatorViewItemHeight = 8.0f;
static const CGFloat kNPRActivityIndicatorViewItemCornerRadius = 4.0f;
static const CGFloat kNPRActivityIndicatorViewAnimationInterval = 0.1f;
static const CGFloat kNPRActivityIndicatorViewMinAlpha = 0.3f;
static const CGFloat kNPRActivityIndicatorViewMaxAlpha = 1.0f;
static const CGFloat kNPRActivityIndicatorViewAnimationDuration = 0.5f;
static const CGFloat kNPRActivityIndicatorViewAnimationDelay = 0.2f;

static const NSInteger kNPRActivityIndicatorViewItemCount = 10;

@interface NPRActivityIndicatorView ()

@property (strong, nonatomic) NSMutableArray *animatingViews;

@property (assign, nonatomic, getter=isAnimating, readwrite) BOOL animating;

@end

@implementation NPRActivityIndicatorView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self commontInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commontInit];
    }
    
    return self;
}

- (void)commontInit {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    CGRect frame = self.frame;
    frame.size = [self intrinsicContentSize];
    self.frame = frame;
    
    _color = [UIColor whiteColor];
    _animatingViews = [NSMutableArray array];
    
    for (NSInteger index = 0; index < kNPRActivityIndicatorViewItemCount; index++) {
        CGSize size = CGSizeMake(kNPRActivityIndicatorViewItemWidth, kNPRActivityIndicatorViewItemHeight);
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        CGRect frame = CGRectMake(x, y, size.width, size.height);
        UIView *item = [[UIView alloc] initWithFrame:frame];
        [self addSubview:item];

        CGFloat radius = (CGRectGetWidth(self.frame) / 2.0f) - (kNPRActivityIndicatorViewItemWidth / 2.0f);
        CGFloat radians = index * ((2.0f * M_PI) / kNPRActivityIndicatorViewItemCount);
        CGFloat circleX = (CGRectGetWidth(self.frame) / 2.0f) + (radius * cos(radians));
        CGFloat circleY = (CGRectGetHeight(self.frame) / 2.0f) + (radius * sin(radians));

        item.center = CGPointMake(circleX, circleY);
        item.transform = CGAffineTransformMakeRotation(radians);
        item.backgroundColor = self.color;
        item.layer.cornerRadius = kNPRActivityIndicatorViewItemCornerRadius;
        item.layer.opacity = kNPRActivityIndicatorViewMinAlpha;

        [_animatingViews addObject:item];
    }

    _animating = NO;
    self.hidden = YES;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = (kNPRActivityIndicatorViewItemCount * 0.375f) * kNPRActivityIndicatorViewItemWidth;
    CGFloat height = width;

    return CGSizeMake(width, height);
}

#pragma mark - Actions

- (void)startAnimating {
    if (!self.isAnimating) {
        self.animating = YES;

        void (^animations)() = ^{
            if (self.animating) {
                [self.animatingViews enumerateObjectsUsingBlock:^(UIView *item, NSUInteger index, BOOL *stop) {
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    animation.fromValue = @(kNPRActivityIndicatorViewMinAlpha);
                    animation.toValue = @(kNPRActivityIndicatorViewMaxAlpha);
                    animation.duration = kNPRActivityIndicatorViewAnimationDuration;
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    animation.autoreverses = NO;

                    CGFloat offset = (index * kNPRActivityIndicatorViewAnimationInterval);

                    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                    animationGroup.duration = kNPRActivityIndicatorViewAnimationInterval * kNPRActivityIndicatorViewItemCount;
                    animationGroup.repeatCount = CGFLOAT_MAX;
                    animationGroup.beginTime = CACurrentMediaTime() + offset;
                    animationGroup.animations = @[animation];
                    
                    [item.layer addAnimation:animationGroup forKey:@"bounce"];
                }];

                self.hidden = NO;
            }
        };

        CGFloat delay = kNPRActivityIndicatorViewAnimationDelay;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), animations);
    }
}

- (void)stopAnimating {
    if (self.isAnimating) {
        self.animating = NO;

        self.hidden = YES;

        [self.animatingViews enumerateObjectsUsingBlock:^(UIView *item, NSUInteger index, BOOL *stop) {
            [item.layer removeAnimationForKey:@"bounce"];
            item.layer.opacity = kNPRActivityIndicatorViewMinAlpha;
        }];
    }
}

@end
