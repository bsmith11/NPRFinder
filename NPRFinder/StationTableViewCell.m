//
//  StationTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "StationTableViewCell.h"
#import "Station.h"
#import "UIFont+NPRFinder.h"
#import "UIColor+NPRFinder.h"
#import "UIImage+NPRFinder.h"
#import "UIScreen+NPRFinder.h"
#import "UILabel+NPRFinder.h"

static const CGFloat kStationTableViewCellTopPadding = 20.0;
static const CGFloat kStationTableViewCellBottomPadding = 20.0;
static const CGFloat kEstimatedStationTableViewCellHeight = 162.0;

@interface StationTableViewCell ()

@property (strong, nonatomic) NSTimer *animationTimer;

@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *followImageView;

@property (assign, nonatomic) CGFloat animationValue;
@property (assign, nonatomic) CGFloat stopAnimationValue;
@property (assign, nonatomic) NSInteger animationCount;
@property (assign, nonatomic) NSInteger animationCountLastFire;

@end

@implementation StationTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.animationValue = 87.8;
    self.animationCount = 0;
    self.animationCountLastFire = 0;
    
    [self setupFrequencyLabel];
    [self setupNameLabel];
    [self setupLocationLabel];
    [self setupFollowImageView];
    
    [self hideFollowImageView];
}

#pragma mark - Setup

- (void)setupFrequencyLabel {
    [self.frequencyLabel npr_setupWithStyle:NPRLabelStyleFocus];
}

- (void)setupNameLabel {
    [self.nameLabel npr_setupWithStyle:NPRLabelStyleDetail];
}

- (void)setupLocationLabel {
    [self.locationLabel npr_setupWithStyle:NPRLabelStyleDetail];
}

- (void)setupFollowImageView {
    [self.followImageView setBackgroundColor:[UIColor clearColor]];
    [self.followImageView setContentMode:UIViewContentModeCenter];
    [self.followImageView setImage:[UIImage npr_followedIcon]];
    [self.followImageView setTintColor:[UIColor npr_foregroundColor]];
}

- (void)setupWithStation:(Station *)station {
    [self.frequencyLabel setText:station.frequency];
    [self.nameLabel setText:station.call];
    [self.locationLabel setText:station.marketLocation];
    
//    switch ([station.signalStrength integerValue]) {
//        case 0:
//        case 1:
//            [self.frequencyLabel setAlpha:(1.0 / 3.0)];
//            break;
//            
//        case 2:
//        case 3:
//            [self.frequencyLabel setAlpha:(2.0 / 3.0)];
//            break;
//            
//        case 4:
//        case 5:
//            [self.frequencyLabel setAlpha:1.0];
//            break;
//
//        default:
//            [self.frequencyLabel setAlpha:(1.0 / 3.0)];
//            break;
//    }
    
}

#pragma mark - Actions

- (void)showFollowImageView {
    [self.followImageView setHidden:NO];
}

- (void)hideFollowImageView {
    [self.followImageView setHidden:YES];
}

#pragma mark - Animations

- (void)hideWithStation:(Station *)station delay:(CGFloat)delay {
    self.alpha = 0.0;
    [self.frequencyLabel setText:@"87.8"];
    
    [self startFadeAnimationWithStation:station delay:delay];
}

- (void)startFadeAnimationWithStation:(Station *)station delay:(CGFloat)delay {
    [UIView animateWithDuration:0.5 delay:delay options:0 animations:^{
        self.alpha = 1.0;
    } completion:nil];
    
    [self.frequencyLabel setText:station.frequency];
    
//    [self startFrequencyAnimationToStation:station];
}

- (void)startFrequencyAnimationToStation:(Station *)station {
    [self.animationTimer invalidate];
    
    self.stopAnimationValue = [station.frequency doubleValue];
    
    self.animationTimer = [NSTimer timerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:@{@"startDate":[NSDate date]}
                                                 repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer *)timer {
//    NSDate *startDate = timer.userInfo[@"startDate"];
    
//    CGFloat elapsedTime = fabs([startDate timeIntervalSinceNow]);
//    
//    DDLogInfo(@"Elapsed Time: %0.1f", elapsedTime);
    
    self.animationCount++;
    
    NSInteger frequency = 0;
    
    CGFloat stopAnimationValueDelta = fabs(self.animationValue - self.stopAnimationValue);
    
    if (stopAnimationValueDelta < 3.0) {
        frequency = 5;
    }
    else if (stopAnimationValueDelta < 6.0) {
        frequency = 3;
    }
    else if (stopAnimationValueDelta < 9.0) {
        frequency = 2;
    }
    else if (stopAnimationValueDelta < 12.0) {
       frequency = 1;
    }
    else if (stopAnimationValueDelta < 15.0) {
        frequency = 2;
    }
    else if (stopAnimationValueDelta < 18.0) {
        frequency = 3;
    }
    else {
        frequency = 5;
    }
    
    [self animateFrequencyLabelWithFrequency:1 timer:timer];
}

- (void)animateFrequencyLabelWithFrequency:(NSInteger)frequency timer:(NSTimer *)timer{
    if (self.animationCount - self.animationCountLastFire >= frequency) {
        self.animationCountLastFire = self.animationCount;
        
        self.animationValue += 0.2;
        
        if (self.animationValue > 108.0) {
            self.animationValue = 87.8;
        }
        
        if (fabs(self.animationValue - self.stopAnimationValue) < 0.3) {
            self.animationValue = self.stopAnimationValue;
            
            [timer invalidate];
        }
        
        [self.frequencyLabel setText:[NSString stringWithFormat:@"%0.1f", self.animationValue]];
    }
}

- (void)stopAnimation {
    [self.animationTimer invalidate];
}

#pragma mark - Height

+ (CGFloat)heightWithStation:(Station *)station {
    CGSize size = CGSizeMake([UIScreen npr_screenWidth], CGFLOAT_MAX);
    
    CGFloat nameLabelHeight = [UILabel npr_heightForText:station.call size:size style:NPRLabelStyleDetail];
    CGFloat locationLabelHeight = [UILabel npr_heightForText:station.marketLocation size:size style:NPRLabelStyleDetail];
    CGFloat frequencyLabelHeight = [UILabel npr_heightForText:station.frequency size:size style:NPRLabelStyleFocus];
    
    return nameLabelHeight + locationLabelHeight + frequencyLabelHeight + kStationTableViewCellBottomPadding + kStationTableViewCellTopPadding;
}

+ (CGFloat)estimatedHeight {
    return kEstimatedStationTableViewCellHeight;
}

@end
