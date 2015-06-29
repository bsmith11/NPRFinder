//
//  NPREmptyListView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/16/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface NPREmptyListView : UIView

- (instancetype)initWithEmptyListText:(NSString *)emptyListText
                           actionText:(NSString *)actionText
                          actionBlock:(void (^)())actionBlock;

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@property (copy, nonatomic) void (^actionBlock)();

@end
