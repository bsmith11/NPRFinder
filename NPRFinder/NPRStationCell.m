//
//  NPRStationCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationCell.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "NPRStation+RZImport.h"
#import "NPRStyleConstants.h"
#import "UIView+NPRAutoLayout.h"

//#import <POP+MCAnimate/POP+MCAnimate.h>

static const CGFloat kNPRStationCellBottomPadding = 13.0f;

@interface NPRStationCell ()

@property (strong, nonatomic) UILabel *frequencyLabel;

@end

@implementation NPRStationCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    [self setupFrequencyLabel];
}

//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//
//    CGPoint scale = highlighted ? CGPointMake(0.9f, 0.9f) : CGPointMake(1.0f, 1.0f);
//    self.pop_spring.pop_scaleXY = scale;
//}

#pragma mark - Setup

- (void)setupFrequencyLabel {
    self.frequencyLabel = [[UILabel alloc] init];
    self.frequencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.frequencyLabel];

    [self.frequencyLabel npr_fillSuperviewHorizontallyWithPadding:kNPRPadding];
    [self.frequencyLabel npr_pinTopToSuperviewWithPadding:kNPRPadding];
    [self.frequencyLabel npr_pinBottomToSuperviewWithPadding:kNPRStationCellBottomPadding];

    self.frequencyLabel.backgroundColor = [UIColor clearColor];
    self.frequencyLabel.textColor = [UIColor npr_foregroundColor];
    self.frequencyLabel.font = [UIFont npr_homeStationFrequencyFont];
    self.frequencyLabel.numberOfLines = 1;
    self.frequencyLabel.lineBreakMode = NSLineBreakByClipping;
    self.frequencyLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setupWithStation:(NPRStation *)station {
    self.frequencyLabel.text = station.frequency;
}

#pragma mark - Size

+ (CGSize)sizeWithStation:(NPRStation *)station width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentLeft;

    CGFloat horizontalPadding = 2.0f * kNPRPadding;
    CGSize boundingSize = CGSizeMake(width - horizontalPadding, CGFLOAT_MAX);
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName:[UIFont npr_homeStationFrequencyFont]};
    
    CGRect boundingRect = [station.frequency boundingRectWithSize:boundingSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attributes
                                                          context:NULL];

    CGFloat verticalPadding = kNPRPadding + kNPRStationCellBottomPadding;
    CGFloat height = ceil(CGRectGetHeight(boundingRect));
    CGSize size = CGSizeMake(width, height + verticalPadding);

    return size;
}

+ (CGSize)sizeWithWidth:(CGFloat)width {
    CGFloat verticalPadding = kNPRPadding + kNPRStationCellBottomPadding;
    CGFloat height = [UIFont npr_homeStationFrequencyFont].lineHeight + verticalPadding;
    CGSize size = CGSizeMake(width, height);

    return size;
}

@end
