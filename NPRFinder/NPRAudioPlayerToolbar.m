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

static const CGFloat kNPRAudioPlayerToolbarMargin = 10.0f;
static const CGFloat kNPRAudioPlayerToolbarPadding = 10.0f;
static const CGFloat kNPRAudioPlayerToolbarTitleSizeModifier = 5.0f / 8.0f;

@interface NPRAudioPlayerToolbar ()

@property (strong, nonatomic) UIBarButtonItem *playBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *pauseBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *stopBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *loadingBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *leftMarginBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightMarginBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *interButtonPaddingBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *fillPaddingBarButtonItem;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

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
    self.tintColor = [UIColor npr_foregroundColor];
    
    self.playBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Play Icon"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(playBarButtonItemTapped)];

    self.pauseBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pause Icon"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(pauseBarButtonItemTapped)];
    
    self.stopBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Stop Icon"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(stopBarButtonItemTapped)];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.color = self.tintColor;
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    self.loadingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    
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
    
    self.state = NPRAudioPlayerToolbarStateNone;
}

- (void)setState:(NPRAudioPlayerToolbarState)state {
    if (_state != state) {
        _state = state;
        
        UIBarButtonItem *actionItem;
        if (_state == NPRAudioPlayerToolbarStateNone) {
            [self setItems:nil animated:NO];
        }
        else {
            switch (_state) {
                case NPRAudioPlayerToolbarStatePlaying:
                    actionItem = self.pauseBarButtonItem;
                    break;
                    
                case NPRAudioPlayerToolbarStatePaused:
                    actionItem = self.playBarButtonItem;
                    break;
                    
                case NPRAudioPlayerToolbarStateLoading:
                    actionItem = self.loadingBarButtonItem;
                    break;
                    
                default:
                    actionItem = self.playBarButtonItem;
                    break;
            }
            
            NSArray *items = @[self.leftMarginBarButtonItem, actionItem, self.interButtonPaddingBarButtonItem, self.stopBarButtonItem, self.fillPaddingBarButtonItem, self.titleBarButtonItem, self.rightMarginBarButtonItem];
            [self setItems:items animated:NO];
        }
        
        if (_state == NPRAudioPlayerToolbarStateLoading) {
            [self.activityIndicatorView startAnimating];
        }
        else {
            [self.activityIndicatorView stopAnimating];
        }
    }
}

- (void)setNowPlayingText:(NSString *)nowPlayingText {
    if (![_nowPlayingText isEqualToString:nowPlayingText]) {
        _nowPlayingText = nowPlayingText;
        
        UILabel *titleLabel = (UILabel *)self.titleBarButtonItem.customView;
        titleLabel.text = _nowPlayingText;
        
        [self sizeTitleLabelToFit:titleLabel];
    }
}

#pragma mark - Actions

- (void)sizeTitleLabelToFit:(UILabel *)titleLabel {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = titleLabel.lineBreakMode;
    paragraphStyle.alignment = titleLabel.textAlignment;
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame) * kNPRAudioPlayerToolbarTitleSizeModifier, CGRectGetHeight(self.frame));
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName:titleLabel.font};
    
    CGRect boundingRect = [titleLabel.text boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attributes
                                                        context:NULL];
    CGRect frame = titleLabel.frame;
    frame.size = boundingRect.size;
    titleLabel.frame = frame;
}

- (void)playBarButtonItemTapped {    
    if ([self.audioPlayerToolbarDelegate respondsToSelector:@selector(audioPlayerToolbarDidSelectPlay:)]) {
        [self.audioPlayerToolbarDelegate audioPlayerToolbarDidSelectPlay:self];
    }
}

- (void)pauseBarButtonItemTapped {
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
