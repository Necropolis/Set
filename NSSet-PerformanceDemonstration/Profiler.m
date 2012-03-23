//
//  Profiler.m
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "Profiler.h"

#include <mach/mach_time.h>
#include <stdint.h>

struct timing_info_t {
    double mean;
    double variance;
    double standard_deviation;
    double mean_ns;
    double variance_ns;
    double standard_deviation_ns;
};

@interface TimingInfo ()

- (id)initWithTimingInfoStruct:(struct timing_info_t)info;

@end

@implementation TimingInfo

#define key_mtu_mean @"mtu_mean"
#define key_mtu_variance @"mtu_variance"
#define key_mtu_standardDeviation @"mtu_standardDeviation"

#define key_ns_mean @"ns_mean"
#define key_ns_variance @"ns_variance"
#define key_ns_standardDeviation @"ns_standardDeviation"

@synthesize mtu_mean=_mtu_mean;
@synthesize mtu_variance=_mtu_variance;
@synthesize mtu_standardDeviation=_mtu_standardDeviation;

@synthesize ns_mean=_ns_mean;
@synthesize ns_variance=_ns_variance;
@synthesize ns_standardDeviation=_ns_standardDeviation;

- (NSComparisonResult)compare:(TimingInfo *)object
{
    NSAssert([object isKindOfClass:[self class]], @"I cannot compare apples to oranges");
    NSComparisonResult r = NSOrderedSame;
    if (_mtu_standardDeviation>object.mtu_standardDeviation)
        r = NSOrderedDescending;
    else if (_mtu_standardDeviation<object.mtu_standardDeviation)
        r = NSOrderedAscending;
    return r;
}

- (id)initWithTimingInfoStruct:(struct timing_info_t)info
{
    self = [super init];
    if (self) {
        _mtu_mean = info.mean;
        _mtu_variance = info.variance;
        _mtu_standardDeviation = info.standard_deviation;
        _ns_mean = info.mean_ns;
        _ns_variance = info.variance_ns;
        _ns_standardDeviation = info.standard_deviation_ns;
    }
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSAssert([aDecoder allowsKeyedCoding], @"I do not allow unkeyed coding.");
    self = [super init];
    if (self) {
        self.mtu_mean = [aDecoder decodeDoubleForKey:key_mtu_mean];
        self.mtu_variance = [aDecoder decodeDoubleForKey:key_mtu_variance];
        self.mtu_standardDeviation = [aDecoder decodeDoubleForKey:key_mtu_standardDeviation];
        self.ns_mean = [aDecoder decodeDoubleForKey:key_ns_mean];
        self.ns_variance = [aDecoder decodeDoubleForKey:key_ns_variance];
        self.ns_standardDeviation = [aDecoder decodeDoubleForKey:key_ns_standardDeviation];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSAssert([aCoder allowsKeyedCoding], @"I do not allow unkeyed coding.");
    [aCoder encodeDouble:_mtu_mean forKey:key_mtu_mean];
    [aCoder encodeDouble:_mtu_variance forKey:key_mtu_variance];
    [aCoder encodeDouble:_mtu_standardDeviation forKey:key_mtu_standardDeviation];
    [aCoder encodeDouble:_ns_mean forKey:key_ns_mean];
    [aCoder encodeDouble:_ns_variance forKey:key_ns_variance];
    [aCoder encodeDouble:_ns_standardDeviation forKey:key_ns_standardDeviation];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        TimingInfo * _object = object;
        return _object.mtu_mean == _mtu_mean && _object.mtu_variance == _mtu_variance && _object.mtu_standardDeviation == _mtu_standardDeviation;
    } else
        return NO;
}



@end

TimingInfo * TimeBlock(size_t iterations, void(^block)())
{
    // http://www.johndcook.com/standard_deviation.html
    double mtu_oldM, mtu_newM, mtu_oldS, mtu_newS;
    
    for (size_t i = 0;
         i < iterations;
         ++i) {
        const uint64_t startTime = mach_absolute_time();
        block();
        const uint64_t endTime = mach_absolute_time();
        const uint64_t elapsedTime = endTime - startTime;
        
        if (i==0) {
            mtu_oldM = mtu_newM = (double)elapsedTime;
            mtu_oldS = 0.0f;
        } else {
            mtu_newM = mtu_oldM + ((double)elapsedTime - mtu_oldM)/(i+1);
            mtu_newS = mtu_oldS + ((double)elapsedTime - mtu_oldM)*((double)elapsedTime - mtu_newM);
            mtu_oldM = mtu_newM;
            mtu_oldS = mtu_newS;
        }    
    }
    
    struct timing_info_t toReturn;
    toReturn.mean = mtu_newM;
    toReturn.variance = mtu_newS/iterations;
    toReturn.standard_deviation = sqrt(mtu_newS/iterations);
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    double numer = (double)info.numer;
    double denom = (double)info.denom;
    toReturn.mean_ns = toReturn.mean * numer / denom;
    toReturn.variance_ns = toReturn.variance * numer / denom;
    toReturn.standard_deviation_ns = toReturn.standard_deviation * numer / denom;
    
    return [[TimingInfo alloc] initWithTimingInfoStruct:toReturn];
    
}
