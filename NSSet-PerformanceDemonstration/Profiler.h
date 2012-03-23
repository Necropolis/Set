//
//  Profiler.h
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimingInfo : NSObject <NSCoding>

@property (assign) double mtu_mean;
@property (assign) double mtu_variance;
@property (assign) double mtu_standardDeviation;

@property (assign) double ns_mean;
@property (assign) double ns_variance;
@property (assign) double ns_standardDeviation;

- (NSComparisonResult)compare:(id)object;

@end

TimingInfo * TimeBlock(size_t, void(^)());
