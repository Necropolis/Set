//
//  main.m
//  NSSet-PerformanceDemonstration
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Profiler.h"

#import "Console.h"
#import "ASCIITable.h"

NSUInteger testDataSize=100000;
NSUInteger numberOfTests=1000;

NSUInteger randomUnder(NSUInteger);
NSArray * shuffleArray(NSArray *);

@interface ASCIITable (ProfilerExtensions)
- (void)addHeader:(NSString *)header;
- (void)addRowsForTimingInfo:(struct timing_info_t)info;
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ASCIITable * t = [[ASCIITable alloc] init];
        
        [t addRow];
        [t addString:@"" withAlign:kLeft colSpan:1 shouldIgnoreWidth:YES];
        [t addString:@"Mean" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
        [t addString:@"Variance" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
        [t addString:@"Standard Deviation" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
        
        
        Print(@"Generating test data...");
        
        NSMutableArray * testData = [[NSMutableArray alloc] initWithCapacity:testDataSize];
        for (NSUInteger i=0;
             i<testDataSize;
             ++i)
            [testData addObject:[NSString stringWithFormat:@"test string number %lu", i]];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableArray hintless best-case addition test...");
        
        [t addHeader:@"NSMutableArray      unhinted best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableArray * a = [[NSMutableArray alloc] init];
            for (NSString * s in testData)
                [a addObject:s];
        })];
        
        PrintLn(@" done!");    
        Print(@"Running NSMutableSet hintless best-case addition test...");
        
        [t addHeader:@"NSMutableSet        unhinted best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableSet * s = [[NSMutableSet alloc] init];
            for (NSString * sz in testData)
                [s addObject:sz];
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableOrderedSet hintless best-case addition test...");
        
        [t addHeader:@"NSMutableOrderedSet unhinted best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableOrderedSet * s = [[NSMutableOrderedSet alloc] init];
            for (NSString *sz in testData)
                [s addObject:sz];
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableArray hinted best-case addition test...");
        
        __block NSMutableArray * mutableTestArray;
        [t addHeader:@"NSMutableArray      hinted   best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestArray = [[NSMutableArray alloc] initWithCapacity:[testData count]];
            for (NSString * s in testData)
                [mutableTestArray addObject:s];
        })];
        __block NSArray * testArrayBestCase = [mutableTestArray copy];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableSet hinted best-case addition test...");
        
        __block NSMutableSet * mutableTestSet;
        [t addHeader:@"NSMutableSet        hinted   best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestSet = [[NSMutableSet alloc] initWithCapacity:[testData count]];
            for (NSString * sz in testData)
                [mutableTestSet addObject:sz];
        })];
        __block NSSet * testSetBestCase = [mutableTestSet copy];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableOrderedSet hinted best-case addition test...");
        
        __block NSMutableOrderedSet * mutableTestOrderedSet;
        [t addHeader:@"NSMutableOrderedSet hinted   best-case  addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestOrderedSet = [[NSMutableOrderedSet alloc] initWithCapacity:[testData count]];
            for (NSString * s in testData)
                [mutableTestOrderedSet addObject:s];
        })];
        __block NSOrderedSet * testOrderedSetBestCase = [mutableTestOrderedSet copy];
        
        PrintLn(@" done!");
        Print(@"Shuffling array...");
        NSArray * shuffledArray = shuffleArray(testData);
        PrintLn(@" done!");
        Print(@"Running NSMutableArray unhinted worst-case addition test...");
        
        [t addHeader:@"NSMutableArray      unhinted worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableArray * a = [[NSMutableArray alloc] init];
            for (NSString * s in shuffledArray)
                [a addObject:s];
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableSet unhinted worst-case addition test...");
        
        [t addHeader:@"NSMutableSet        unhinted worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableSet * s = [[NSMutableSet alloc] init];
            for (NSString * sz in shuffledArray)
                [s addObject:sz];
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableOrderedSet unhinted worst-case addition test...");
        
        [t addHeader:@"NSMutableOrderedSet unhinted worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] init];
            for (NSString * s in shuffledArray)
                [os addObject:s];
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableArray hinted worst-case addition test...");
        
        [t addHeader:@"NSMutableArray      hinted   worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestArray = [[NSMutableArray alloc] initWithCapacity:[shuffledArray count]];
            for (NSString * s in shuffledArray)
                [mutableTestArray addObject:s];
        })];
        __block NSArray * testArrayWorstCase = [mutableTestArray copy];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableSet hinted worst-case addition test...");
        
        [t addHeader:@"NSMutableSet        hinted   worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestSet = [[NSMutableSet alloc] initWithCapacity:[shuffledArray count]];
            for (NSString * sz in shuffledArray)
                [mutableTestSet addObject:sz];
        })];
        __block NSSet * testSetWorstCase = [mutableTestSet copy];
        
        PrintLn(@" done!");
        Print(@"Running NSMutableOrderedSet hinted worst-case addition test...");
        
        [t addHeader:@"NSMutableOrderedSet hinted   worst-case addition"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            mutableTestOrderedSet = [[NSMutableOrderedSet alloc] initWithCapacity:[shuffledArray count]];
            for (NSString * s in shuffledArray)
                [mutableTestOrderedSet addObject:s];
        })];
        __block NSOrderedSet * testOrderedSetWorstCase = [mutableTestOrderedSet copy];
        
        PrintLn(@" done!");
        Print(@"Getting a list of random objects from testData...");
        
        NSUInteger numberOfRandomObjects = testDataSize / 2;
        NSMutableArray * randomObjects = [[NSMutableArray alloc] initWithCapacity:numberOfRandomObjects];
        srandomdev();
        for (NSUInteger i = 0;
             i < numberOfRandomObjects;
             ++i) {
            NSUInteger itemIdx = randomUnder([testData count]);
            [randomObjects addObject:[testData objectAtIndex:itemIdx]];
            [testData removeObjectAtIndex:itemIdx];
        }
        
        PrintLn(@" done!");
        Print(@"Running NSArray containsObject: best-case test...");
        
        // #define NSARRAY_PROFILE_HANDICAP() MAX(numberOfTests/2048, 100)
        // it's so slow... still running after three hours. Let's try something easier.
#define NSARRAY_PROFILE_HANDICAP() 7
        
        [t addHeader:@"NSArray containsObject: best-case"];
        [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{ // sad experience has shown that this takes for-freakin ever to run
            for (NSString * s in randomObjects)
                NSCAssert([testArrayBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSSet containsObject: test...");
        
        [t addHeader:@"NSSet containsObject: best-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testSetBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSOrderedSet containsObject: best-case test...");
        
        [t addHeader:@"NSOrderedSet containsObject: best-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testOrderedSetBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSArray containsObject: worst-case test...");
        
        [t addHeader:@"NSArray containsObject: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{
            for (NSString * s in randomObjects)
                NSCAssert([testArrayWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSSet containsObject: worst-case test...");
        
        [t addHeader:@"NSSet containsObject: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testSetWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSOrderedSet containsObject: worst-case test...");
        
        [t addHeader:@"NSOrderedSet containsObject: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testOrderedSetWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSArray indexOfObject: best-case test...");
        
        [t addHeader:@"NSArray indexOfObject: best-case"];
        [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{ // this should take a long time because containsObject took a long time
            for (NSString * s in randomObjects)
                NSCAssert([testArrayBestCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an array, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSSet member: best-case test...");
        
        [t addHeader:@"NSSet member: best-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert(s == [testSetBestCase member:s], @"Looking for string \"%@\" in a set, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSOrderedSet indexOfObject: best-case test...");
        
        [t addHeader:@"NSOrderedSet indexOfObject: best-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testOrderedSetBestCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an ordered set, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSArray indexOfObject: worst-case test...");
        
        [t addHeader:@"NSArray indexOfObject: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{
            for (NSString * s in randomObjects)
                NSCAssert([testArrayWorstCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an array, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSSet member: worst-case test...");
        
        [t addHeader:@"NSSet member: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert(s == [testSetWorstCase member:s], @"Looking for string \"%@\" in set, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        Print(@"Running NSOrderedSet indexOfObject: worst-case test...");
        
        [t addHeader:@"NSOrderedSet indexOfObject: worst-case"];
        [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
            for (NSString * s in randomObjects)
                NSCAssert([testOrderedSetWorstCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in ordered set, but couldn't find it!", s);
        })];
        
        PrintLn(@" done!");
        
        PrintLn(@"\n\nResults:");
        PrintLn(@"%@", t);
        
    }
    return 0;
}

/* see http://www.mikeash.com/pyblog/friday-qa-2011-03-18-random-numbers.html */
NSUInteger randomUnder(NSUInteger topPlusOne)
{
    unsigned two31 = 1U << 31;
    unsigned maxUsable = (two31 / topPlusOne) * topPlusOne;
    
    while(1)
    {
        unsigned num = random();
        if(num < maxUsable)
            return num % topPlusOne;
    }
}

NSArray * shuffleArray(NSArray * unshuffledArray)
{
    NSMutableIndexSet * usedIndices = [[NSMutableIndexSet alloc] init];
    NSMutableArray * shuffledArray = [NSMutableArray arrayWithCapacity:[unshuffledArray count]];
    NSUInteger unshuffledArrayCount = [unshuffledArray count];
    NSUInteger idx = randomUnder(unshuffledArrayCount);
    for (NSUInteger i = 0;
         i < unshuffledArrayCount;
         ++i) {
        while ([usedIndices containsIndex:idx])
            idx = randomUnder(unshuffledArrayCount);
        [shuffledArray addObject:[unshuffledArray objectAtIndex:idx]];
        [usedIndices addIndex:idx];
    }
    return [shuffledArray copy];
}

@implementation ASCIITable (ProfilerExtensions)
- (void)addHeader:(NSString *)header
{
    [self addRow];
    [self addString:header withAlign:kLeft colSpan:1 shouldIgnoreWidth:YES];
}
- (void)addRowsForTimingInfo:(struct timing_info_t)info
{
    [self addRow];
    [self addString:@"  MTU Timings:" withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.mean withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.variance withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.standard_deviation withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    
    [self addRow];
    [self addString:@"  Nanoseconds:" withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.mean_ns withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.variance_ns withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
    [self addDouble:info.standard_deviation_ns withAlign:kRight colSpan:1 shouldIgnoreWidth:NO];
}
@end
