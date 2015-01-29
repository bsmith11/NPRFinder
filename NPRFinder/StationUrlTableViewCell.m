//
//  StationUrlTableViewCell.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/11/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "StationUrlTableViewCell.h"
#import "UIButton+NPRFinder.h"
#import "Station.h"
#import "StationUrl.h"
#import "UIView+NPRConstraints.h"

static const CGFloat kStationUrlTableViewCellHeight = 35.0;

@interface StationUrlTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *homePageButton;

@end

@implementation StationUrlTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupFacebookButton];
    [self setupTwitterButton];
    [self setupHomePageButton];
}

#pragma mark - Setup

- (void)setupFacebookButton {
    [self.facebookButton npr_setupWithStyle:NPRButtonStyleFacebookButton
                                     target:self
                                     action:@selector(facebookButtonPressed)];
}

- (void)setupTwitterButton {
    [self.twitterButton npr_setupWithStyle:NPRButtonStyleTwitterButton
                                    target:self
                                    action:@selector(twitterButtonPressed)];
}

- (void)setupHomePageButton {
    [self.homePageButton npr_setupWithStyle:NPRButtonStyleHomePageButton
                                     target:self
                                     action:@selector(homePageButtonPressed)];
}

- (void)setupWithStation:(Station *)station {
    NSArray *types = [station.urlsDictionary allKeys];
    
    BOOL hasFacebook = [types containsObject:@(StationUrlTypeFacebookUrl)];
    BOOL hasTwitter = [types containsObject:@(StationUrlTypeTwitterFeed)];
    BOOL hasHomePage = [types containsObject:@(StationUrlTypeOrganizationHomePage)];
    
    [self.facebookButton setEnabled:hasFacebook];
    [self.twitterButton setEnabled:hasTwitter];
    [self.homePageButton setEnabled:hasHomePage];
}

#pragma mark - Actions

- (void)facebookButtonPressed {
    if ([self.delegate respondsToSelector:@selector(facebookButtonPressed)]) {
        [self.delegate facebookButtonPressed];
    }
}

- (void)twitterButtonPressed {
    if ([self.delegate respondsToSelector:@selector(twitterButtonPressed)]) {
        [self.delegate twitterButtonPressed];
    }
}

- (void)homePageButtonPressed {
    if ([self.delegate respondsToSelector:@selector(homePageButtonPressed)]) {
        [self.delegate homePageButtonPressed];
    }
}

#pragma mark - Height

+ (CGFloat)height {
    return kStationUrlTableViewCellHeight;
}

@end
