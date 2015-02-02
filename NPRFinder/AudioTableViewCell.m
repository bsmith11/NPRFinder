//
//  AudioTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "AudioTableViewCell.h"
#import "UIButton+NPRFinder.h"

static const CGFloat kAudioTableViewCellHeight = 100.0;

@interface AudioTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation AudioTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupPlayButton];
}

#pragma mark - Setup

- (void)setupPlayButton {
    [self.playButton npr_setupWithStyle:NPRButtonStylePlayButton
                                 target:self
                                 action:@selector(playButtonPressed)];
}

- (void)setupWithStation:(Station *)station status:(BOOL)playing {
    [self.playButton setSelected:playing];
}

#pragma mark - Actions

- (void)playButtonPressed {
    self.playButton.selected = !self.playButton.selected;

    if ([self.delegate respondsToSelector:@selector(didSelectWithState:indexPath:)]) {
        [self.delegate didSelectWithState:self.playButton.selected indexPath:self.indexPath];
    }
}

#pragma mark - Height

+ (CGFloat)heightWithStation:(Station *)station {
    return kAudioTableViewCellHeight;
}

@end
