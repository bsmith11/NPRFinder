//
//  Station.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "Station.h"
#import "StationUrl.h"

@interface Station ()

@end

@implementation Station

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    Station *station = (Station *)object;
    if ([station.organizationId integerValue] == [self.organizationId integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [@"organizationId" hash] ^ [self.organizationId hash];
}

- (NSString *)marketLocation {
    return [NSString stringWithFormat:@"%@, %@", self.marketCity, self.marketState];
}

- (BOOL)hasDisplayableStationUrls {
    NSArray *types = [self.urlsDictionary allKeys];
    
    BOOL hasFacebook = [types containsObject:@(StationUrlTypeFacebookUrl)];
    BOOL hasTwitter = [types containsObject:@(StationUrlTypeTwitterFeed)];
    BOOL hasHomePage = [types containsObject:@(StationUrlTypeOrganizationHomePage)];
    
    return hasFacebook || hasTwitter || hasHomePage;
}

- (NSDictionary *)urlsDictionary {
    if (!_urlsDictionary) {
        NSMutableDictionary *mutableUrlsDictionary = [NSMutableDictionary dictionary];
        
        for (StationUrl *stationUrl in self.urls) {
            [mutableUrlsDictionary setObject:stationUrl forKey:stationUrl.typeId];
        }
        
        _urlsDictionary = [mutableUrlsDictionary copy];
    }
    
    return _urlsDictionary;
}

#pragma mark - JSON Serializing Delegate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"guid":@"guid",
             @"organizationId":@"org_id",
             @"name":@"name",
             @"title":@"title",
             @"call":@"call",
             @"frequency":@"frequency",
             @"band":@"band",
             @"tagline":@"tagline",
             @"marketCity":@"market_city",
             @"marketState":@"market_state",
             @"format":@"format",
             @"musicOnly":@"music_only",
             @"status":@"status",
             @"areaCode":@"area_code",
             @"phone":@"phone",
             @"phoneExtension":@"phone_extension",
             @"fax":@"fax",
             @"signal":@"signal",
             @"signalStrength":@"signal_strength",
             @"urls":@"urls"};
}

+ (NSValueTransformer *)urlsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:StationUrl.class];
}

#pragma mark - Mock Objects

+ (NSDictionary *)mockStationJsonWithFrequency:(NSString *)frequency signalStrength:(NSNumber *)signalStrength {
    NSDictionary *json = @{@"guid" : @"4fcf701003f74f83946fc90857d03ef8",
                           @"org_id" : @"305",
                           @"name": @"WAMU 88.5",
                           @"title": @"WAMU-FM",
                           @"call": @"WAMU",
                           @"frequency": frequency,
                           @"band": @"FM",
                           @"tagline": @"The Mind Is Our Medium",
                           @"address": @[@"American University",
                                         @"4400 Massachusetts Ave., NW",
                                         @"Washington",
                                         @"DC",
                                         @"20016"],
                           @"market_city": @"Washington",
                           @"market_state": @"DC",
                           @"format": @"Public Radio",
                           @"music_only": @"0",
                           @"status": @"1",
                           @"email": @"feedback@wamu.org",
                           @"area_code": [NSNull null],
                           @"phone": @"2028851200",
                           @"phone_extension": [NSNull null],
                           @"fax": @"2028851280",
                           @"signal": @"strong",
                           @"signal_strength": [signalStrength stringValue],
                           @"urls": @[@{@"type_id": @"1",
                                        @"type_name": @"Organization Home Page",
                                        @"title": @"WAMU Homepage",
                                        @"href": @"http://wamu.org"},
                                      @{@"type_id": @"2",
                                        @"type_name": @"Program Schedule",
                                        @"title": @"Program Schedule",
                                        @"href": @"http://wamu.org/programs/schedule/"},
                                      @{@"type_id": @"3",
                                        @"type_name": @"Pledge Page",
                                        @"title": @"Support  WAMU",
                                        @"href": @"http://wamu.org/support/donate/"},
                                      @{@"type_id": @"4",
                                        @"type_name": @"Organization Home Page",
                                        @"title": @"WAMU Homepage",
                                        @"href": @"http://wamu.org"}],
                           @"homepage": @"http://wamu.org",
                           @"donation_url": @"http://wamu.org/support/donate/",
                           @"logo": @"http://media.npr.org/images/stations/logos/wamu_fm.gif"};
    
    return json;
}

+ (instancetype)mockStation {
    NSError *error;
    Station *station = [MTLJSONAdapter modelOfClass:Station.class fromJSONDictionary:[Station mockStationJsonWithFrequency:@"92.3" signalStrength:@5] error:&error];
    
    return station;
}

@end
