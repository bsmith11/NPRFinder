//
//  NPRAudioPlayerToolbar.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/12/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NPRAudioPlayerToolbarState) {
    NPRAudioPlayerToolbarStatePlaying,
    NPRAudioPlayerToolbarStatePaused,
    NPRAudioPlayerToolbarStateLoading,
    NPRAudioPlayerToolbarStateNone
};

@class NPRAudioPlayerToolbar;

@protocol NPRAudioPlayerToolbarDelegate <NSObject>

- (void)audioPlayerToolbarDidSelectPlay:(NPRAudioPlayerToolbar *)audioPlayerToolbar;
- (void)audioPlayerToolbarDidSelectPause:(NPRAudioPlayerToolbar *)audioPlayerToolbar;
- (void)audioPlayerToolbarDidSelectStop:(NPRAudioPlayerToolbar *)audioPlayerToolbar;

@end

@interface NPRAudioPlayerToolbar : UIToolbar

@property (copy, nonatomic) NSString *nowPlayingText;

@property (weak, nonatomic) id <NPRAudioPlayerToolbarDelegate> audioPlayerToolbarDelegate;

@property (assign, nonatomic) NPRAudioPlayerToolbarState state;

@end
