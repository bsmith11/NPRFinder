//
//  StationDetailsTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "StationDetailsTableViewCell.h"
#import "UILabel+NPRFinder.h"
#import "UIImage+NPRFinder.h"
#import "UIColor+NPRFinder.h"

static const CGFloat kStationDetailsTableViewCellHeight = 70.0;

@interface StationDetailsTableViewCell ()

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation StationDetailsTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupTitleLabel];
    [self setupCountLabel];
    [self setupArrowImageView];
}

#pragma mark - Setup

- (void)setupTitleLabel {
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleDetail];
}

- (void)setupCountLabel {
    [self.countLabel npr_setupWithStyle:NPRLabelStyleDetail];
    [self.countLabel setTextAlignment:NSTextAlignmentRight];
}

- (void)setupArrowImageView {
    [self.arrowImageView setBackgroundColor:[UIColor clearColor]];
    [self.arrowImageView setContentMode:UIViewContentModeCenter];
    [self.arrowImageView setImage:[UIImage npr_forwardIcon]];
    [self.arrowImageView setTintColor:[UIColor npr_foregroundColor]];
}

- (void)setupWithText:(NSString *)text count:(NSInteger)count indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    
    [self.titleLabel setText:text];
    [self.countLabel setText:[NSString stringWithFormat:@"%ld", (long)count]];
}

#pragma mark - Height

+ (CGFloat)height {
    return kStationDetailsTableViewCellHeight;
}

@end
