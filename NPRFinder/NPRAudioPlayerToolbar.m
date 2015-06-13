//
//  NPRAudioPlayerToolbar.m
//  NPRFinder
//
//  Created by Bradley Smith on 6/12/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAudioPlayerToolbar.h"

#import "UIColor+NPRStyle.h"
#import "UIFont+NPRStyle.h"
#import "UIImage+NPRStyle.h"

static const CGFloat kNPRAudioPlayerToolbarMargin = 10.0f;
static const CGFloat kNPRAudioPlayerToolbarPadding = 10.0f;

typedef NS_ENUM(NSInteger, NPRAudioPlayerToolbarState) {
    NPRAudioPlayerToolbarStateNone,
    NPRAudioPlayerToolbarStatePlaying,
    NPRAudioPlayerToolbarStatePaused
};

@interface NPRAudioPlayerToolbar ()

@property (strong, nonatomic) UIBarButtonItem *playBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *pauseBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *stopBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *leftMarginBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightMarginBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *interButtonPaddingBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *fillPaddingBarButtonItem;

@property (assign, nonatomic) NPRAudioPlayerToolbarState state;

@end

@implementation NPRAudioPlayerToolbar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    [self setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny];
    self.translucent = NO;
    self.barTintColor = [UIColor darkGrayColor];
    self.tintColor = [UIColor npr_highlightColor];
    
    self.playBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage npr_playIcon]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(playBarButtonItemTapped)];

    self.pauseBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage npr_pauseIcon]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(pauseBarButtonItemTapped)];
    
    self.stopBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage npr_stopIcon]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(stopBarButtonItemTapped)];
    
    self.leftMarginBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:nil
                                                                                 action:nil];
    
    self.rightMarginBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    self.interButtonPaddingBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                         target:nil
                                                                                         action:nil];
    
    self.fillPaddingBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = self.tintColor;
    titleLabel.font = [UIFont npr_audioPlayerToolbarFont];
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.titleBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    self.leftMarginBarButtonItem.width = kNPRAudioPlayerToolbarMargin;
    self.rightMarginBarButtonItem.width = kNPRAudioPlayerToolbarMargin;
    self.interButtonPaddingBarButtonItem.width = kNPRAudioPlayerToolbarPadding;
    
    self.state = NPRAudioPlayerToolbarStatePlaying;
}

- (void)setState:(NPRAudioPlayerToolbarState)state {
    _state = state;
    
    UIBarButtonItem *actionItem;
    if (self.state == NPRAudioPlayerToolbarStateNone) {
        [self setItems:nil animated:NO];
    }
    else {
        switch (state) {
            case NPRAudioPlayerToolbarStatePlaying:
                actionItem = self.pauseBarButtonItem;
                break;
                
            case NPRAudioPlayerToolbarStatePaused:
                actionItem = self.playBarButtonItem;
                break;
                
            default:
                actionItem = self.playBarButtonItem;
                break;
        }
        
        NSArray *items = @[self.leftMarginBarButtonItem, actionItem, self.interButtonPaddingBarButtonItem, self.stopBarButtonItem, self.fillPaddingBarButtonItem, self.titleBarButtonItem, self.rightMarginBarButtonItem];
        [self setItems:items animated:NO];
    }
}

- (void)setNowPlayingText:(NSString *)nowPlayingText {
    _nowPlayingText = nowPlayingText;
    
    UILabel *titleLabel = (UILabel *)self.titleBarButtonItem.customView;
    titleLabel.text = _nowPlayingText;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = titleLabel.lineBreakMode;
    paragraphStyle.alignment = titleLabel.textAlignment;
    
    CGFloat modifier = 5.0f / 8.0f;
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame) * modifier, CGRectGetHeight(self.frame));
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName:titleLabel.font};
    
    CGRect boundingRect = [titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    CGRect frame = titleLabel.frame;
    frame.size = boundingRect.size;
    titleLabel.frame = frame;
}

#pragma mark - Actions

- (void)playBarButtonItemTapped {
    self.state = NPRAudioPlayerToolbarStatePlaying;
    
    if ([self.audioPlayerToolbarDelegate respondsToSelector:@selector(audioPlayerToolbarDidSelectPlay:)]) {
        [self.audioPlayerToolbarDelegate audioPlayerToolbarDidSelectPlay:self];
    }
}

- (void)pauseBarButtonItemTapped {
    self.state = NPRAudioPlayerToolbarStatePaused;
    
    if ([self.audioPlayerToolbarDelegate respondsToSelector:@selector(audioPlayerToolbarDidSelectPause:)]) {
        [self.audioPlayerToolbarDelegate audioPlayerToolbarDidSelectPause:self];
    }
}

- (void)stopBarButtonItemTapped {
    if ([self.audioPlayerToolbarDelegate respondsToSelector:@selector(audioPlayerToolbarDidSelectStop:)]) {
        [self.audioPlayerToolbarDelegate audioPlayerToolbarDidSelectStop:self];
    }
}

@end
