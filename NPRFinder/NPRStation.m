//
//  NPRStation.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRStation.h"

#import "NPRAudioStream+RZImport.h"

@interface NPRStation ()

@end

@implementation NPRStation

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    NPRStation *station = (NPRStation *)object;
    if ([station.organizationID integerValue] == [self.organizationID integerValue]) {
        return YES;
    }
    
    return [super isEqual:object];
}

- (NSArray *)audioStreams {
    if (!_audioStreams) {
        _audioStreams = [NSArray array];
    }
    
    return _audioStreams;
}

- (NPRAudioStream *)preferredAudioStream {
    NSPredicate *typePredicate = [self typePredicateWithType:NPRAudioStreamTypeAAC];
    NSPredicate *primaryPredicate = [self primaryPredicate:YES];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, primaryPredicate]];
    NSArray *results = [self.audioStreams filteredArrayUsingPredicate:compoundPredicate];
    NPRAudioStream *audioStream;
    
    if ([results count] > 0) {
        audioStream = [results firstObject];
    }
    else {
        typePredicate = [self typePredicateWithType:NPRAudioStreamTypeMP3];
        compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, primaryPredicate]];
        results = [self.audioStreams filteredArrayUsingPredicate:compoundPredicate];
        
        if ([results count] > 0) {
            audioStream = [results firstObject];
        }
        else {
            audioStream = nil;
        }
    }
    
    return audioStream;
}

- (NSPredicate *)typePredicateWithType:(NPRAudioStreamType)type {
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"type", @(type)];
    
    return typePredicate;
}

- (NSPredicate *)primaryPredicate:(BOOL)primary {
    NSPredicate *primaryPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"primaryStream", @(primary)];
    
    return primaryPredicate;
}

- (NSString *)marketLocation {
    NSMutableString *marketLocation = [NSMutableString string];
    BOOL hasCity = (self.marketCity && ![self.marketCity isEqualToString:@""]);
    BOOL hasState = (self.marketState && ![self.marketState isEqualToString:@""]);

    if (hasCity) {
        [marketLocation appendString:self.marketCity];

        if (hasState) {
            [marketLocation appendString:@", "];
            [marketLocation appendString:self.marketState];
        }
    }
    else if (hasState) {
        [marketLocation appendString:self.marketState];
    }

    return marketLocation;
}

@end
