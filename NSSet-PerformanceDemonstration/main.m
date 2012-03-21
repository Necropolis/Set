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
BOOL tagsFoundInArgs(NSSet *, NSString *, ...) NS_REQUIRES_NIL_TERMINATION;

@interface ASCIITable (ProfilerExtensions)
- (void)addHeader:(NSString *)header;
- (void)addRowsForTimingInfo:(struct timing_info_t)info;
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSSet * args = [NSSet setWithArray:[[NSProcessInfo processInfo] arguments]];
        
        if (tagsFoundInArgs(args, @"help", nil)) {
            PrintLn(@"Possible arguments:\n"
                    @"\n"
                    @"  all                           all tests (takes a while)\n"
                    @"  arr-add                       all array addition tests\n"
                    @"  arr-add-hintless              all hintless array addition tests\n"
                    @"  arr-add-hintless-best         best-case hintless array addition test\n"
                    @"  arr-add-hintless-worst        worst-case hintless array addition test\n"
                    @"  arr-add-hinted                all hinted array addition tests\n"
                    @"  arr-add-hinted-best           best-case hinted array addition test\n"
                    @"  arr-add-hinted-worst          worst-case hinted array addition test\n"
                    @"  set-add                       all set addition tests\n"
                    @"  set-add-hintless              all hintless set addition tests\n"
                    @"  set-add-hintless-best         best-case hintless set addition test\n"
                    @"  set-add-hintless-worst        worst-case hintless set addition test\n"
                    @"  set-add-hinted                all hinted set addition tests\n"
                    @"  set-add-hinted-best           best-case hinted set addition test\n"
                    @"  set-add-hinted-worst          worst-case hinted set addition test\n"
                    @"  ord-set-add                   all ordered set addition tests\n"
                    @"  ord-set-add-hintless          all hintless ordered set addition tests\n"
                    @"  ord-set-add-hintless-best     best-case hintless ordered set addition test\n"
                    @"  ord-set-add-hintless-wrost    worst-case hintless ordered set addition test\n"
                    @"  ord-set-add-hinted            all hinted ordered set addition tests\n"
                    @"  ord-set-add-hinted-best       best-case hinted ordered set addition test\n"
                    @"  ord-set-add-hinted-worst      worst-case hinted ordered set addition test\n"
                    @"  arr-containsObject            all array containsObject: lookup tests (very very very long running)\n"
                    @"  arr-containsObject-best       best-case array containsObject: lookup test (very long running)\n"
                    @"  arr-containsObject-worst      worst-case array containsObject: lookup test (very very long running)\n"
                    @"  set-containsObject            all set containsObject: lookup tests\n"
                    @"  set-containsObject-best       best-case set containsObject: lookup test\n"
                    @"  set-containsObject-worst      worst-case set containsObject: lookup test\n"
                    @"  ord-set-containsObject        all ordered set containsObject: lookup tests\n"
                    @"  ord-set-containsObject-best   best-case ordered set containsObject: lookup test\n"
                    @"  ord-set-containsObject-worst  worst-case ordered set containsObject: lookup test\n"
                    @"  arr-indexOfObject             all array indexOfObject: lookup tests (very very very long running)\n"
                    @"  arr-indexOfObject-best        best-case array indexOfObject: lookup test (very long running)\n"
                    @"  arr-indexOfObject-worst       worst-case array indexOfObject: lookup test (very very long running)\n"
                    @"  set-member                    all set member: lookup tests\n"
                    @"  set-member-best               best-case set member: lookup test\n"
                    @"  set-member-worst              worst-case set member: lookup test\n"
                    @"  ord-set-indexOfObject         all ordered set indexOfObject: lookup tests\n"
                    @"  ord-set-indexOfObject-best    best-case ordered set indexOfObject: lookup test\n"
                    @"  ord-set-indexOfObject-worst   worst-case ordered set indexOfObject: lookup test\n");
            
            return 0;
        }
        
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
            [testData addObject:[NSString stringWithFormat:@"%lu", i]];
        
        NSArray * testArrayBestCase = [testData copy];
        NSSet * testSetBestCase = [NSSet setWithArray:testArrayBestCase];
        NSOrderedSet * testOrderedSetBestCase = [NSOrderedSet orderedSetWithArray:testArrayBestCase];
        
        PrintLn(@" done!");
        Print(@"Getting a list of random objects from testData...");
        
        NSUInteger numberOfRandomObjects = testDataSize / 2;
        NSMutableArray * randomObjects = [[NSMutableArray alloc] initWithCapacity:numberOfRandomObjects];
        NSMutableArray * copy_testData = [testData mutableCopy];
        srandomdev();
        for (NSUInteger i = 0;
             i < numberOfRandomObjects;
             ++i) {
            NSUInteger itemIdx = randomUnder([copy_testData count]);
            [randomObjects addObject:[copy_testData objectAtIndex:itemIdx]];
            [copy_testData removeObjectAtIndex:itemIdx];
        }
        copy_testData = nil;
        
        PrintLn(@" done!");
        Print(@"Shuffling array...");
        NSArray * testArrayWorstCase = shuffleArray(testData);
        NSSet * testSetWorstCase = [NSSet setWithArray:testArrayWorstCase];
        NSOrderedSet * testOrderedSetWorstCase = [NSOrderedSet orderedSetWithArray:testArrayWorstCase];
        PrintLn(@" done!");
        
//        PrintLn(@"> [testData count]\n => %lu", [testData count]);
//        PrintLn(@"> [testArrayWorstCase count]\n => %lu", [testArrayWorstCase count]);
//        PrintLn(@"> [testSetWorstCase count]\n => %lu", [testSetWorstCase count]);
//        PrintLn(@"> [testOrderedSetWorstCase count]\n => %lu", [testOrderedSetWorstCase count]);
//        
//        for (NSString * s in testData) {
//            NSArray * matches = [testArrayWorstCase filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//                return [s isEqual:evaluatedObject];
//            }]];
//            if ([matches count]>1) {
//                PrintLn(@"Found %@", matches);
//            } else if ([matches count]==0) {
//                PrintLn(@"didn't find \"%@\"", s);
//            }
//            if (![testArrayWorstCase containsObject:s]) {
//                PrintLn(@"testArrayWorstCase doesn't think it has \"%@\"", s);
//            }
//            NSUInteger idx = [testArrayWorstCase indexOfObject:s];
//            if (idx == NSNotFound) {
//                PrintLn(@"testArrayWorstCase thinks that \"%@\" is at NSNotFound.", s);
//            }
//        }
//        
//        for (NSString * s in randomObjects) {
//            NSArray * matches = [testArrayWorstCase filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//                return [s isEqual:evaluatedObject];
//            }]];
//            if ([matches count]>1) {
//                PrintLn(@"Found %@", matches);
//            } else if ([matches count]==0) {
//                PrintLn(@"didn't find \"%@\"", s);
//            }
//            if (![testArrayWorstCase containsObject:s]) {
//                PrintLn(@"testArrayWorstCase doesn't think it has \"%@\"", s);
//            }
//            NSUInteger idx = [testArrayWorstCase indexOfObject:s];
//            if (idx == NSNotFound) {
//                PrintLn(@"testArrayWorstCase thinks that \"%@\" is at NSNotFound.", s);
//            }
//        }
        
// #define NSARRAY_PROFILE_HANDICAP() MAX(numberOfTests/2048, 100)
        // it's so slow... still running after three hours. Let's try something easier.
#define NSARRAY_PROFILE_HANDICAP() 7
        
        if (tagsFoundInArgs(args, @"arr-add-hintless-best",         @"arr-add-hintless",        @"arr-add",     @"all", nil)) {
            Print(@"Running NSMutableArray hintless best-case addition test...");
            [t addHeader:@"NSMutableArray      unhinted best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] init];
                for (NSString * s in testData)
                    [a addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-add-hintless-worst",        @"arr-add-hintless",        @"arr-add",     @"all", nil)) {
            Print(@"Running NSMutableArray unhinted worst-case addition test...");
            [t addHeader:@"NSMutableArray      unhinted worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] init];
                for (NSString * s in testArrayWorstCase)
                    [a addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-add-hintless-best",         @"set-add-hintless",        @"set-add",     @"all", nil)) {
            Print(@"Running NSMutableSet hintless best-case addition test...");
            [t addHeader:@"NSMutableSet        unhinted best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableSet * s = [[NSMutableSet alloc] init];
                for (NSString * sz in testData)
                    [s addObject:sz];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-add-hintless-worst",        @"set-add-hintless",        @"set-add",     @"all", nil)) {
            Print(@"Running NSMutableSet unhinted worst-case addition test...");
            [t addHeader:@"NSMutableSet        unhinted worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableSet * s = [[NSMutableSet alloc] init];
                for (NSString * sz in testArrayWorstCase)
                    [s addObject:sz];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-add-hintless-best",     @"ord-set-add-hintless",    @"ord-set-add", @"all", nil)) {
            Print(@"Running NSMutableOrderedSet hintless best-case addition test...");
            [t addHeader:@"NSMutableOrderedSet unhinted best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableOrderedSet * s = [[NSMutableOrderedSet alloc] init];
                for (NSString *sz in testData)
                    [s addObject:sz];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-add-hintless-worst",    @"ord-set-add-hintless",    @"ord-set-add", @"all", nil)) {
            Print(@"Running NSMutableOrderedSet unhinted worst-case addition test...");
            [t addHeader:@"NSMutableOrderedSet unhinted worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] init];
                for (NSString * s in testArrayWorstCase)
                    [os addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-add-hinted-best",           @"arr-add-hinted",          @"arr-add",     @"all", nil)) {
            Print(@"Running NSMutableArray hinted best-case addition test...");
            [t addHeader:@"NSMutableArray      hinted   best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[testData count]];
                for (NSString * s in testData)
                    [a addObject:s];
            })];            
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-add-hinted-worst",          @"arr-add-hinted",          @"arr-add",     @"all", nil)) {
            Print(@"Running NSMutableArray hinted worst-case addition test...");            
            [t addHeader:@"NSMutableArray      hinted   worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[testArrayWorstCase count]];
                for (NSString * s in testArrayWorstCase)
                    [a addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-add-hinted-best",           @"set-add-hinted",          @"set-add",     @"all", nil)) {
            Print(@"Running NSMutableSet hinted best-case addition test...");
            [t addHeader:@"NSMutableSet        hinted   best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] initWithCapacity:[testData count]];
                for (NSString * sz in testData)
                    [ms addObject:sz];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-add-hinted-worst",          @"set-add-hinted",          @"set-add",     @"all", nil)) {
            Print(@"Running NSMutableSet hinted worst-case addition test...");
            [t addHeader:@"NSMutableSet        hinted   worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] initWithCapacity:[testArrayWorstCase count]];
                for (NSString * sz in testArrayWorstCase)
                    [ms addObject:sz];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-add-hinted-best",       @"ord-set-add-hinted",      @"ord-set-add", @"all", nil)) {
            Print(@"Running NSMutableOrderedSet hinted best-case addition test...");
            [t addHeader:@"NSMutableOrderedSet hinted   best-case  addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] initWithCapacity:[testData count]];
                for (NSString * s in testData)
                    [os addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-add-hinted-worst",      @"ord-set-add-hinted",      @"ord-set-add", @"all", nil)) {
            Print(@"Running NSMutableOrderedSet hinted worst-case addition test...");
            [t addHeader:@"NSMutableOrderedSet hinted   worst-case addition"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] initWithCapacity:[testArrayWorstCase count]];
                for (NSString * s in testArrayWorstCase)
                    [os addObject:s];
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-containsObject-best",       @"arr-containsObject",      @"all", nil)) {
            Print(@"Running NSArray containsObject: best-case test...");
            [t addHeader:@"NSArray containsObject: best-case"];
            [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{ // sad experience has shown that this takes for-freakin ever to run
                for (NSString * s in randomObjects)
                    NSCAssert([testArrayBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-containsObject-worst",      @"arr-containsObject",      @"all", nil)) {
            Print(@"Running NSArray containsObject: worst-case test...");
            [t addHeader:@"NSArray containsObject: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testArrayWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-containsObject-best",       @"set-containsObject",      @"all", nil)) {
            Print(@"Running NSSet containsObject: best-case test...");
            [t addHeader:@"NSSet containsObject: best-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testSetBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-containsObject-worst",      @"set-containsObject",      @"all", nil)) {
            Print(@"Running NSSet containsObject: worst-case test...");
            [t addHeader:@"NSSet containsObject: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testSetWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-containsObject-best",   @"ord-set-containsObject",  @"all", nil)) {
            Print(@"Running NSOrderedSet containsObject: best-case test...");
            [t addHeader:@"NSOrderedSet containsObject: best-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testOrderedSetBestCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-containsObject:worst",  @"ord-set-containsObject",  @"all", nil)) {
            Print(@"Running NSOrderedSet containsObject: worst-case test...");
            [t addHeader:@"NSOrderedSet containsObject: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testOrderedSetWorstCase containsObject:s]==YES, @"Looking for string \"%@\" which should be present, but isn't!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-indexOfObject-best",        @"arr-indexOfObject",       @"all", nil)) {
            Print(@"Running NSArray indexOfObject: best-case test...");
            [t addHeader:@"NSArray indexOfObject: best-case"];
            [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{ // this should take a long time because containsObject took a long time
                for (NSString * s in randomObjects)
                    NSCAssert([testArrayBestCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an array, but couldn't find it!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"arr-indexOfObject-worst",       @"arr-indexOfObject",       @"all", nil)) {
            Print(@"Running NSArray indexOfObject: worst-case test...");
            [t addHeader:@"NSArray indexOfObject: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(NSARRAY_PROFILE_HANDICAP(), ^{
                for (NSString * s in randomObjects) {
                    NSCAssert([testArrayWorstCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an array, but couldn't find it!", s);
                }
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-member-best",               @"set-member",              @"all", nil)) {
            Print(@"Running NSSet member: best-case test...");
            [t addHeader:@"NSSet member: best-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert(s == [testSetBestCase member:s], @"Looking for string \"%@\" in a set, but couldn't find it!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"set-member-worst",              @"set-member",              @"all", nil)) {
            Print(@"Running NSSet member: worst-case test...");
            [t addHeader:@"NSSet member: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert(s == [testSetWorstCase member:s], @"Looking for string \"%@\" in set, but couldn't find it!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-indexOfObject-best",    @"ord-set-indexOfObject",   @"all", nil)) {
            Print(@"Running NSOrderedSet indexOfObject: best-case test...");
            [t addHeader:@"NSOrderedSet indexOfObject: best-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testOrderedSetBestCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in an ordered set, but couldn't find it!", s);
            })];
            PrintLn(@" done!");
        }
        if (tagsFoundInArgs(args, @"ord-set-indexOfObject-worst",   @"ord-set-indexOfObject",   @"all", nil)) {
            Print(@"Running NSOrderedSet indexOfObject: worst-case test...");
            [t addHeader:@"NSOrderedSet indexOfObject: worst-case"];
            [t addRowsForTimingInfo:TimeBlock(numberOfTests, ^{
                for (NSString * s in randomObjects)
                    NSCAssert([testOrderedSetWorstCase indexOfObject:s]!=NSNotFound, @"Looking for string \"%@\" in ordered set, but couldn't find it!", s);
            })];
            PrintLn(@" done!");
        }
        
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

BOOL tagsFoundInArgs(NSSet * args, NSString * firstObject, ...)
{
    BOOL found=NO;
    va_list va_args;
    va_start(va_args, firstObject);
    for (NSString * s = firstObject;
         s != nil;
         s = va_arg(va_args, NSString *)) {
        if ([args containsObject:s]) {
            found = YES;
            break;
        }
    }
    va_end(va_args);
    return found;
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
