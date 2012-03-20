//
//  Profiler.h
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

struct timing_info_t {
    double mean;
    double variance;
    double standard_deviation;
    double mean_ns;
    double variance_ns;
    double standard_deviation_ns;
};

struct timing_info_t TimeBlock(size_t, void(^)());

NSArray * TimingInfoMTURow(struct timing_info_t);
NSArray * TimingInfoNSRow(struct timing_info_t);
void NSMutableStringAppendToLength(NSMutableString *, NSString *, NSUInteger);
