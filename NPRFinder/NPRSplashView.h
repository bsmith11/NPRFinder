//
//  NPRSplashView.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/28/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import UIKit;

@interface NPRSplashView : UIView

- (void)expandLeftViewWithCompletion:(void (^)(BOOL finished))completion;
- (void)expandRightViewWithCompletion:(void (^)(BOOL finished))completion;

@end
