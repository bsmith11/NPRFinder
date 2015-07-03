//
//  NPRStationViewModel.h
//  NPRFinder
//
//  Created by Bradley Smith on 7/1/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

@import Foundation;

#import "NPRStation+RZImport.h"

@interface NPRStationViewModel : NSObject

- (instancetype)initWithStation:(NPRStation *)station;

@property (strong, nonatomic, readonly) NPRStation *station;

@end
