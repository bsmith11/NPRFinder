//
//  ProgramTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "ProgramTableViewCell.h"
#import "Program.h"
#import "UILabel+NPRFinder.h"

static const CGFloat kProgramTableViewCellHeight = 44.0;

@interface ProgramTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ProgramTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupTitleLabel];
}

#pragma mark - Setup

- (void)setupTitleLabel {
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleDetail];
}

- (void)setupWithProgram:(Program *)program {
    [self.titleLabel setText:program.title];
}

#pragma mark - Height

+ (CGFloat)height {
    return kProgramTableViewCellHeight;
}

@end
