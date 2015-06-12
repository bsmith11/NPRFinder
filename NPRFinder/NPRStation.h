//
//  NPRStation.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NPRSignalStrength) {
    NPRSignalStrengthWeak = 1,
    NPRSignalStrengthMedium = 3,
    NPRSignalStrengthStrong = 5
};

@interface NPRStation : NSObject

@property (copy, nonatomic) NSString *guid;
@property (copy, nonatomic) NSNumber *organizationId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *call;
@property (copy, nonatomic) NSString *frequency;
@property (copy, nonatomic) NSString *band;
@property (copy, nonatomic) NSString *tagline;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *marketCity;
@property (copy, nonatomic) NSString *marketState;
@property (copy, nonatomic) NSString *format;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *areaCode;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *phoneExtension;
@property (copy, nonatomic) NSString *fax;
@property (copy, nonatomic) NSArray *urls;

@property (assign, nonatomic) NPRSignalStrength signalStrength;
@property (assign, nonatomic, getter=isOpen) BOOL open;
@property (assign, nonatomic, getter=isMusicOnly) BOOL musicOnly;

- (NSString *)marketLocation;

@end
