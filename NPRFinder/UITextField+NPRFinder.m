//
//  UITextField+NPRFinder.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/8/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "UITextField+NPRFinder.h"
#import "UIFont+NPRFinder.h"
#import "UIColor+NPRFinder.h"

@implementation UITextField (NPRFinder)

- (void)npr_setupWithStyle:(NPRTextFieldStyle)style placeholderText:(NSString *)placeholderText {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFont:[UIFont npr_titleFont]];
    [self setTextAlignment:NSTextAlignmentLeft];
    [self setTextColor:[UIColor npr_foregroundColor]];
    [self setTintColor:[UIColor npr_highlightColor]];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont npr_titleFont],
                                 NSForegroundColorAttributeName: [UIColor npr_foregroundColor]};
    NSAttributedString *attributedPlaceholderText = [[NSAttributedString alloc] initWithString:placeholderText attributes:attributes];
    [self setAttributedPlaceholder:attributedPlaceholderText];
}

@end
