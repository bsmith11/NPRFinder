//
//  TaglineTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "TaglineTableViewCell.h"
#import "Station.h"
#import "UILabel+NPRFinder.h"
#import "UIScreen+NPRFinder.h"
#import "UIColor+NPRFinder.h"

static const CGFloat kBottomSeparatorHorizontalMargin = 22.0;
static const CGFloat kBottomSeparatorTopMargin = 11.0;
static const CGFloat kBottomSeparatorBottomMargin = 11.0;

@interface TaglineTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorViewTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorViewBottom;

@end

@implementation TaglineTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupTaglineLabel];
    [self setupBottomSeparatorView];
}

#pragma mark - Setup

- (void)setupTaglineLabel {
    [self.taglineLabel npr_setupWithStyle:NPRLabelStyleDetail];
}

- (void)setupBottomSeparatorView {
    [self.bottomSeparatorView setBackgroundColor:[UIColor npr_foregroundColor]];
    [self.bottomSeparatorViewLeading setConstant:kBottomSeparatorHorizontalMargin];
    [self.bottomSeparatorViewTrailing setConstant:kBottomSeparatorHorizontalMargin];
    [self.bottomSeparatorViewTop setConstant:kBottomSeparatorTopMargin];
    [self.bottomSeparatorViewBottom setConstant:kBottomSeparatorBottomMargin];
}

- (void)setupWithStation:(Station *)station {
    [self.taglineLabel setText:station.tagline];
}

#pragma mark - Height

+ (CGFloat)heightWithStation:(Station *)station {
    CGSize size = CGSizeMake([UIScreen npr_screenWidth], CGFLOAT_MAX);
    CGFloat taglineHeight = [UILabel npr_heightForText:station.tagline size:size style:NPRLabelStyleDetail];
    
    return taglineHeight + kBottomSeparatorTopMargin + kBottomSeparatorBottomMargin;
}

@end
