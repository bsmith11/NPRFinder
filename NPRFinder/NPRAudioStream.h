//
//  NPRAudioStream.h
//  NPRFinder
//
//  Created by Bradley Smith on 6/13/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NPRAudioStreamType) {
    NPRAudioStreamTypeMP3 = 10,
    NPRAudioStreamTypeWindowsMedia = 11,
    NPRAudioStreamTypeRealMedia = 12,
    NPRAudioStreamTypeAAC = 13
};

@interface NPRAudioStream : NSObject

@property (copy, nonatomic) NSURL *URL;
@property (copy, nonatomic) NSString *streamGUID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *typeName;

@property (assign, nonatomic) NPRAudioStreamType type;
@property (assign, nonatomic, getter=isPrimaryStream) BOOL primaryStream;

@end
