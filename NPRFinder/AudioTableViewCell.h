//
//  AudioTableViewCell.h
//  NPRFinder
//
//  Created by Bradley Smith on 2/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;

@protocol AudioTableViewCellDelegate <NSObject>

- (void)didSelectWithState:(BOOL)state indexPath:(NSIndexPath *)indexPath;

@end

@interface AudioTableViewCell : UITableViewCell

- (void)setupWithStation:(Station *)station status:(BOOL)playing;

+ (CGFloat)heightWithStation:(Station *)station;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id <AudioTableViewCellDelegate> delegate;

@end
