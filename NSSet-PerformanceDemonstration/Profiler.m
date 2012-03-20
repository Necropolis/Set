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

struct timing_info_t TimeBlock(size_t iterations, void(^block)())
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
    
    return toReturn;
    
}

NSArray * TimingInfoMTURow(struct timing_info_t t)
{
    return [NSArray arrayWithObjects:
            [NSMutableString stringWithFormat:@"%f", t.mean],
            [NSMutableString stringWithFormat:@"%f", t.variance],
            [NSMutableString stringWithFormat:@"%f", t.standard_deviation], nil];
}
NSArray * TimingInfoNSRow(struct timing_info_t t)
{
    return [NSArray arrayWithObjects:
            [NSMutableString stringWithFormat:@"%f", t.mean_ns],
            [NSMutableString stringWithFormat:@"%f", t.variance_ns],
            [NSMutableString stringWithFormat:@"%f", t.standard_deviation_ns], nil];
}

void NSMutableStringAppendToLength(NSMutableString * s, NSString * a, NSUInteger l)
{
    for (NSUInteger i = [s length];
         i < l;
         i += [a length]) [s appendString:a];
}
