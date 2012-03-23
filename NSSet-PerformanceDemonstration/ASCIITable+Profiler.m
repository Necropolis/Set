//
//  ASCIITable+Profiler.m
//  Set
//
//  Created by Christopher Miller on 3/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "ASCIITable+Profiler.h"

#import "Profiler.h"

@implementation ASCIITable (Profiler)

- (void)addHeader:(NSString *)header withTimingInfo:(TimingInfo *)info
{
    if (info==nil) return;
    [self addHeader:header];
    [self addRowsForTimingInfo:info];
}

- (void)addHeader:(NSString *)header
{
    [self addRow];
    [self addString:header withAlign:kLeft colSpan:1 shouldIgnoreWidth:YES];
}

- (void)addRowsForTimingInfo:(TimingInfo *)info
{
    [self addRow];
    [self addString:@"  MTU Timings:" withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.mtu_mean withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.mtu_variance withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.mtu_standardDeviation withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    
    [self addRow];
    [self addString:@"  Nanoseconds:" withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.ns_mean withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.ns_variance withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.ns_standardDeviation withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
}

@end
