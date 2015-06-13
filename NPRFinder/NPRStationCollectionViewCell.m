//
//  NPRStationCollectionViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStationCollectionViewCell.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIImage+NPRStyle.h"
#import "NPRStation+RZImport.h"

@interface NPRStationCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *musicOnlyImageView;

@end

@implementation NPRStationCollectionViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupFrequencyLabel];
    [self setupMusicOnlyImageView];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    NSIndexPath *indexPath = layoutAttributes.indexPath;
    UIColor *color;
    if (indexPath.row % 3 == 0) {
        color = [UIColor npr_redColor];
    }
    else if (indexPath.row % 3 == 1) {
        color = [UIColor npr_blackColor];
    }
    else {
        color = [UIColor npr_blueColor];
    }
    
    self.backgroundColor = color;
}

#pragma mark - Setup

- (void)setupFrequencyLabel {
    self.frequencyLabel.backgroundColor = [UIColor clearColor];
    self.frequencyLabel.textColor = [UIColor npr_foregroundColor];
    self.frequencyLabel.font = [UIFont npr_homeStationFrequencyFont];
    self.frequencyLabel.numberOfLines = 1;
    self.frequencyLabel.lineBreakMode = NSLineBreakByClipping;
    self.frequencyLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setupMusicOnlyImageView {
    self.musicOnlyImageView.backgroundColor = [UIColor clearColor];
    self.musicOnlyImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.musicOnlyImageView.image = [UIImage npr_musicIcon];
    self.musicOnlyImageView.tintColor = [UIColor npr_foregroundColor];
}

- (void)setupWithStation:(NPRStation *)station {
    self.frequencyLabel.text = station.frequency;
    self.musicOnlyImageView.hidden = !station.isMusicOnly;
}

#pragma mark - Size

+ (CGSize)sizeWithStation:(NPRStation *)station width:(CGFloat)width {
    return CGSizeZero;
}

@end
