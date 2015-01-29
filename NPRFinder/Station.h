//
//  Station.h
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Station : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *guid;
@property (copy, nonatomic) NSNumber *organizationId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *call;
@property (copy, nonatomic) NSString *frequency;
@property (copy, nonatomic) NSString *band;
@property (copy, nonatomic) NSString *tagline;
//@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *marketCity;
@property (copy, nonatomic) NSString *marketState;
@property (copy, nonatomic) NSString *format;
@property (copy, nonatomic, getter=isMusicOnly) NSNumber *musicOnly;
@property (copy, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *areaCode;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *phoneExtension;
@property (copy, nonatomic) NSString *fax;
@property (copy, nonatomic) NSString *signal;
@property (copy, nonatomic) NSNumber *signalStrength;
@property (copy, nonatomic) NSArray *urls;
@property (strong, nonatomic) NSDictionary *urlsDictionary;

- (NSString *)marketLocation;
- (BOOL)hasDisplayableStationUrls;

+ (NSDictionary *)mockStationJsonWithFrequency:(NSString *)frequency signalStrength:(NSNumber *)signalStrength;
+ (instancetype)mockStation;

@end
