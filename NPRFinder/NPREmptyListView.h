//
//  NPREmptyListView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/16/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, NPREmptyListViewActionState) {
    NPREmptyListViewActionStateSettings,
    NPREmptyListViewActionStatePermissionRequest,
    NPREmptyListViewActionStateRetry
};

@class NPREmptyListView;

@protocol NPREmptyListViewDelegate <NSObject>

- (void)didSelectActionInEmptyListView:(NPREmptyListView *)emptyListView state:(NPREmptyListViewActionState)state;

@end

@interface NPREmptyListView : UIView

- (void)setupWithError:(NSError *)error;
- (NSString *)errorText;
- (NSString *)actionText;

@property (weak, nonatomic) id <NPREmptyListViewDelegate> delegate;

@end
