//
//  UILabel+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/7/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UILabel+NPRFinder.h"
#import "UIFont+NPRFinder.h"
#import "UIColor+NPRFinder.h"
#import "UIView+NPRFinder.h"

static const CGFloat kTextAnimationDuration = 0.4;

@implementation UILabel (NPRFinder)

- (void)npr_setupWithStyle:(NPRLabelStyle)style {
    switch (style) {
        case NPRLabelStyleTitle:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFont:[UIFont npr_titleFont]];
            [self setTextAlignment:NSTextAlignmentLeft];
            [self setTextColor:[UIColor npr_foregroundColor]];
            break;
            
        case NPRLabelStyleDetail:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFont:[UIFont npr_detailFont]];
            [self setTextAlignment:NSTextAlignmentCenter];
            [self setTextColor:[UIColor npr_foregroundColor]];
            break;
            
        case NPRLabelStyleFocus:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFont:[UIFont npr_focusFont]];
            [self setTextAlignment:NSTextAlignmentCenter];
            [self setTextColor:[UIColor npr_foregroundColor]];
            break;
            
        case NPRLabelStyleSplash:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFont:[UIFont npr_splashFont]];
            [self setTextAlignment:NSTextAlignmentCenter];
            [self setTextColor:[UIColor npr_foregroundColor]];
            break;
            
        case NPRLabelStyleError:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFont:[UIFont npr_titleFont]];
            [self setTextAlignment:NSTextAlignmentCenter];
            [self setTextColor:[UIColor npr_foregroundColor]];
            break;
            
        default:
            break;
    }
}

- (void)npr_setText:(NSString *)text animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self.layer removeAllAnimations];
    
    if (animated) {
        [UIView animateWithDuration:kTextAnimationDuration
                         animations:^{
                             [self setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [self setText:text];
                                 [self sizeToFit];
                                 
                                 [UIView animateWithDuration:kTextAnimationDuration animations:^{
                                     [self setAlpha:1.0];
                                 } completion:completion];
                             }
                             else {
                                 [self setText:text];
                                 [self sizeToFit];
                             }
                         }];
    }
    else {
        [self setText:text];
        [self sizeToFit];
        
        if (completion) {
            completion(YES);
        }
    }
}

- (void)npr_hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self setUserInteractionEnabled:NO];
    
    [self npr_setAlpha:0.0
              duration:kTextAnimationDuration
              animated:animated
            completion:completion];
}

- (void)npr_showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self setUserInteractionEnabled:YES];
    
    [self npr_setAlpha:1.0
              duration:kTextAnimationDuration
              animated:animated
            completion:completion];
}

+ (CGFloat)npr_heightForText:(NSString *)text size:(CGSize)size style:(NPRLabelStyle)style {
    NSArray *alignmentArray = @[@(NSTextAlignmentLeft),
                                @(NSTextAlignmentCenter),
                                @(NSTextAlignmentCenter),
                                @(NSTextAlignmentCenter)];
    
    NSArray *lineBreakArray = @[@(NSLineBreakByWordWrapping),
                                @(NSLineBreakByWordWrapping),
                                @(NSLineBreakByWordWrapping),
                                @(NSLineBreakByWordWrapping)];
    
    NSArray *fontArray = @[[UIFont npr_titleFont],
                           [UIFont npr_detailFont],
                           [UIFont npr_focusFont],
                           [UIFont npr_splashFont]];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setAlignment:[alignmentArray[style] integerValue]];
    [paragraphStyle setLineBreakMode:[lineBreakArray[style] integerValue]];
    
    NSDictionary *attributes = @{NSFontAttributeName:fontArray[style],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect boundingRect = [text boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    
    return ceil(CGRectGetHeight(boundingRect));
}

@end
