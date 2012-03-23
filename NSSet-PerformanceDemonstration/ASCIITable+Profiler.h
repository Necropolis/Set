//
//  ASCIITable+Profiler.h
//  Set
//
//  Created by Christopher Miller on 3/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "ASCIITable.h"

@class TimingInfo;

@interface ASCIITable (Profiler)

- (void)addHeader:(NSString *)header withTimingInfo:(TimingInfo *)info;
- (void)addHeader:(NSString *)header;
- (void)addRowsForTimingInfo:(TimingInfo *)info;

@end
