//
//  ProfileHarness.m
//  Set
//
//  Created by Christopher Miller on 3/21/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "ProfileHarness.h"

#import "Flags.h"
#import "Console.h"
#import "ASCIITable.h"
#import "Profiler.h"
#import "NSArray+Randomness.h"
#import "ASCIITable+Profiler.h"

@interface ProfileHarness ()

@property (strong) NSSet * args;

// used for addition tests
@property (strong) NSArray * testData;
@property (strong) NSArray * randomObjects;
// used for lookup tests
@property (strong) NSArray * arrayTestDataBestCase;
@property (strong) NSSet * setTestDataBestCase;
@property (strong) NSOrderedSet * orderedSetTestDataBestCase;
@property (strong) NSArray * arrayTestDataWorstCase;
@property (strong) NSSet * setTestDataWorstCase;
@property (strong) NSOrderedSet * orderedSetTestDataWorstCase;
@property (strong) NSArray * randomObjectsForArrayTest;

- (BOOL)hasArg:(NSString *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (void)reportTiming:(TimingInfo *)t forJob:(NSString *)job;
- (void)archive;

@end

@implementation ProfileHarness

@synthesize concurrentProfiles=_concurrentProfiles;
@synthesize results=_results;
@synthesize cachedResults=_cachedResults;
@synthesize testDataSize=_testDataSize;
@synthesize numberOfTests=_numberOfTests;
@synthesize args=_args;
@synthesize testData=_testData;
@synthesize arrayTestDataBestCase=_arrayTestDataBestCase;
@synthesize setTestDataBestCase=_setTestDataBestCase;
@synthesize orderedSetTestDataBestCase=_orderedSetTestDataBestCase;
@synthesize arrayTestDataWorstCase=_arrayTestDataWorstCase;
@synthesize setTestDataWorstCase=_setTestDataWorstCase;
@synthesize orderedSetTestDataWorstCase=_orderedSetTestDataWorstCase;
@synthesize randomObjects=_randomObjects;
@synthesize randomObjectsForArrayTest=_randomObjectsForArrayTest;

- (id)initWithFile:(NSString *)filename
{
    self = [self init];
    if (self) {
        _cachedResults = [filename stringByExpandingTildeInPath];
        
        NSFileManager * fmanager =
        [NSFileManager defaultManager];
        if ([fmanager fileExistsAtPath:_cachedResults]) {
            id oldResults = [NSKeyedUnarchiver unarchiveObjectWithFile:_cachedResults];
            NSAssert([oldResults isKindOfClass:[NSDictionary class]], @"Results need to be a dictionary");
            _results = [oldResults mutableCopy];
        }
    }
    return self;
}

- (void)run
{
    self.args = [NSSet setWithArray:[[NSProcessInfo processInfo] arguments]];
    
    Print(@">>> Generating test data...");
    
    NSMutableArray * mtd = [[NSMutableArray alloc] initWithCapacity:_testDataSize];
    for (NSUInteger i=0;
         i<_testDataSize;
         ++i)
        [mtd addObject:[NSString stringWithFormat:@"%lu", i]];
    
    self.testData = [mtd copy];
    
    self.arrayTestDataBestCase = self.testData;
    self.setTestDataBestCase = [NSSet setWithArray:_testData];
    self.orderedSetTestDataBestCase = [NSOrderedSet orderedSetWithArray:_testData];
    
    self.randomObjects = [_testData fs_arrayByShuffling];
    self.randomObjectsForArrayTest = [_testData fs_arrayWithNRandomObjects:[_testData count] / 1024];
    
    self.arrayTestDataWorstCase = [_testData fs_arrayByShuffling];
    self.setTestDataWorstCase = [NSSet setWithArray:_arrayTestDataWorstCase];
    self.orderedSetTestDataWorstCase = [NSOrderedSet orderedSetWithArray:_arrayTestDataWorstCase];
    
    PrintLn(@" done!");
    
    dispatch_queue_t report_back_q = dispatch_queue_create("report back", DISPATCH_QUEUE_SERIAL);
    
    if ([self hasArg:kfArrayAddHintlessBestCase, kfArrayAddHintless, kfArrayAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayAddHintlessBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] init];
                for (NSString * s in _testData)
                    [a addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayAddHintlessBestCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayAddHintlessWorstCase, kfArrayAddHintless, kfArrayAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayAddHintlessWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] init];
                for (NSString * s in _randomObjects)
                    [a addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayAddHintlessWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayAddHintedBestCase, kfArrayAddHinted, kfArrayAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayAddHintedBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[_testData count]];
                for (NSString * s in _testData)
                    [a addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayAddHintedBestCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayAddHintedWorstCase, kfArrayAddHinted, kfArrayAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayAddHintedWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[_randomObjects count]];
                for (NSString * s in _randomObjects)
                    [a addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayAddHintedWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfSetAddHintlessBestCase, kfSetAddHintless, kfSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetAddHintlessBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] init];
                for (NSString * s in _testData)
                    [ms addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetAddHintlessBestCase];
            });
        }]];
    }
    if ([self hasArg:kfSetAddHintlessWorstCase, kfSetAddHintless, kfSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetAddHintlessWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] init];
                for (NSString * s in _randomObjects)
                    [ms addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetAddHintlessWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfSetAddHintedBestCase, kfSetAddHinted, kfSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetAddHintedBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] initWithCapacity:[_testData count]];
                for (NSString * s in _testData)
                    [ms addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetAddHintedBestCase];
            });
        }]];
    }
    if ([self hasArg:kfSetAddHintedWorstCase, kfSetAddHinted, kfSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetAddHintedWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableSet * ms = [[NSMutableSet alloc] initWithCapacity:[_randomObjects count]];
                for (NSString * s in _randomObjects)
                    [ms addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetAddHintedWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetAddHintlessBestCase, kfOrderedSetAddHintless, kfOrderedSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetAddHintlessBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] init];
                for (NSString * s in _testData)
                    [os addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetAddHintlessBestCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetAddHintlessWorstCase, kfOrderedSetAddHintless, kfOrderedSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetAddHintlessWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] init];
                for (NSString * s in _randomObjects)
                    [os addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetAddHintlessWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetAddHintedBestCase, kfOrderedSetAddHinted, kfOrderedSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetAddHintedBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] initWithCapacity:[_testData count]];
                for (NSString * s in _testData)
                    [os addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetAddHintedBestCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetAddHintedWorstCase, kfOrderedSetAddHinted, kfOrderedSetAdd, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetAddHintedWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                NSMutableOrderedSet * os = [[NSMutableOrderedSet alloc] initWithCapacity:[_randomObjects count]];
                for (NSString * s in _randomObjects)
                    [os addObject:s];
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetAddHintedWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayContainsObjectBestCase, kfArrayContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayContainsObjectBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjectsForArrayTest)
                    NSAssert([_arrayTestDataBestCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _arrayTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayContainsObjectBestCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayContainsObjectWorstCase, kfArrayContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayContainsObjectWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjectsForArrayTest)
                    NSAssert([_arrayTestDataWorstCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _arrayTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayContainsObjectWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfSetContainsObjectBestCase, kfSetContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetContainsObjectBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_setTestDataBestCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _setTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetContainsObjectBestCase];
            });
        }]];
    }
    if ([self hasArg:kfSetContainsObjectWorstCase, kfSetContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetContainsObjectWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_setTestDataWorstCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _setTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetContainsObjectWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetContainsObjectBestCase, kfOrderedSetContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetContainsObjectBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_orderedSetTestDataBestCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _orderedSetTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetContainsObjectBestCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetContainsObjectWorstCase, kfOrderedSetContainsObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetContainsObjectWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_orderedSetTestDataWorstCase containsObject:s]==YES, @"NSString \"%@\" isn't present in _orderedSetTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetContainsObjectWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayIndexOfObjectBestCase, kfArrayIndexOfObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayIndexOfObjectBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjectsForArrayTest)
                    NSAssert([_arrayTestDataBestCase indexOfObject:s]!=NSNotFound, @"NSString \"%@\" isn't present in _arrayTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayIndexOfObjectBestCase];
            });
        }]];
    }
    if ([self hasArg:kfArrayIndexOfObjectWorstCase, kfArrayIndexOfObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfArrayIndexOfObjectWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjectsForArrayTest)
                    NSAssert([_arrayTestDataWorstCase indexOfObject:s]!=NSNotFound, @"NSString \"%@\" isn't present in _arrayTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfArrayIndexOfObjectWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfSetMemberBestCase, kfSetMember, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetMemberBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_setTestDataBestCase member:s]!=nil, @"NSString \"%@\" isn't present in _setTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetMemberBestCase];
            });
        }]];
    }
    if ([self hasArg:kfSetMemberWorstCase, kfSetMember, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfSetMemberWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_setTestDataWorstCase member:s]!=nil, @"NSString \"%@\" isn't present in _setTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfSetMemberWorstCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetIndexOfObjectBestCase, kfOrderedSetIndexOfObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetIndexOfObjectBestCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_orderedSetTestDataBestCase indexOfObject:s]!=NSNotFound, @"NSString \"%@\" isn't present in _orderedSetTestDataBestCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetIndexOfObjectBestCase];
            });
        }]];
    }
    if ([self hasArg:kfOrderedSetIndexOfObjectWorstCase, kfOrderedSetIndexOfObject, kfAll, nil]) {
        [_concurrentProfiles addOperation:[NSBlockOperation blockOperationWithBlock:^{
            PrintLn(@">>> Running %@", kfOrderedSetIndexOfObjectWorstCase);
            TimingInfo * t = TimeBlock(_numberOfTests, ^{
                for (NSString * s in _randomObjects)
                    NSAssert([_orderedSetTestDataWorstCase indexOfObject:s]!=NSNotFound, @"NSString \"%@\" isn't present in _orderedSetTestDataWorstCase", s);
            });
            dispatch_sync(report_back_q, ^{
                [self reportTiming:t forJob:kfOrderedSetIndexOfObjectWorstCase];
            });
        }]];
    }
    
    [_concurrentProfiles waitUntilAllOperationsAreFinished];
    
    [self archive];
}

- (BOOL)hasArg:(NSString *)firstObject, ...
{
    BOOL found=NO;
    va_list va_args;
    va_start(va_args, firstObject);
    for (NSString * s = firstObject;
         s != nil;
         s = va_arg(va_args, NSString *)) {
        if ([_args containsObject:s]) {
            found = YES;
            break;
        }
    }
    va_end(va_args);
    return found;
}

- (void)reportTiming:(TimingInfo *)t forJob:(NSString *)job
{
    TimingInfo * ot = [_results objectForKey:job];
    TimingInfo * bt = t;
    if (ot) { // note that these comparisons might be reversed
        NSComparisonResult r = [t compare:ot];
        if (r == NSOrderedAscending) // t > ot
            bt = t;
        else if (r == NSOrderedDescending) // t < ot
            bt = ot;
    }
    [_results setObject:bt forKey:job];
    PrintLn(@"<<< Finished %@", job);
}

- (void)archive
{
    [NSKeyedArchiver archiveRootObject:self.results toFile:self.cachedResults];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        _concurrentProfiles = [[NSOperationQueue alloc] init];
        [_concurrentProfiles setMaxConcurrentOperationCount:2]; // half my current CPU core count; fiddle with this at your liesure.
        _results = [NSMutableDictionary dictionary];
        _numberOfTests = 1000;
        _testDataSize = 100000;
    }
    return self;
}

- (NSString *)description
{
    ASCIITable * t = [[ASCIITable alloc] init];
    t.spacesBetweenColumns = 3;
    
    [t addRow];
    [t addString:@"" withAlign:kLeft colSpan:1 shouldIgnoreWidth:YES];
    [t addString:@"Mean" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
    [t addString:@"Variance" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
    [t addString:@"Standard Deviation" withAlign:kCenter colSpan:1 shouldIgnoreWidth:NO];
    
    [t addHeader:@"NSMutableArray addObject:"];
    [t addHeader:@"NSMutableArray alloc/init addObject: best-case" withTimingInfo:[_results objectForKey:kfArrayAddHintlessBestCase]];
    [t addHeader:@"NSMutableArray alloc/init addObject: worst-case" withTimingInfo:[_results objectForKey:kfArrayAddHintlessWorstCase]];
    [t addHeader:@"NSMutableArray alloc/initWithCapacity: addObject: best-case" withTimingInfo:[_results objectForKey:kfArrayAddHintedBestCase]];
    [t addHeader:@"NSMutableArray alloc/initWithCapacity: addObject: worst-case" withTimingInfo:[_results objectForKey:kfArrayAddHintedWorstCase]];
    
    [t addHeader:@"NSMutableSet addObject:"];
    [t addHeader:@"NSMutableSet alloc/init addObject: best-case" withTimingInfo:[_results objectForKey:kfSetAddHintlessBestCase]];
    [t addHeader:@"NSMutableSet alloc/init addObject: worst-case" withTimingInfo:[_results objectForKey:kfSetAddHintlessWorstCase]];
    [t addHeader:@"NSMutableSet alloc/initWithCapacity: addObject: best-case" withTimingInfo:[_results objectForKey:kfSetAddHintedBestCase]];
    [t addHeader:@"NSMutableSet alloc/initWithCapacity: addObject: worst-case" withTimingInfo:[_results objectForKey:kfSetAddHintedWorstCase]];
    
    [t addHeader:@"NSMutableOrderedSet addObject:"];
    [t addHeader:@"NSMutableOrderedSet alloc/init addObject: best-case" withTimingInfo:[_results objectForKey:kfOrderedSetAddHintlessBestCase]];
    [t addHeader:@"NSMutableOrderedSet alloc/init addObject: worst-case" withTimingInfo:[_results objectForKey:kfOrderedSetAddHintlessWorstCase]];
    [t addHeader:@"NSMutableOrderedSet alloc/initWithCapacity: addObject: best-case" withTimingInfo:[_results objectForKey:kfOrderedSetAddHintedBestCase]];
    [t addHeader:@"NSMutableOrderedSet alloc/initWithCapacity: addObject: worst-case" withTimingInfo:[_results objectForKey:kfOrderedSetAddHintedWorstCase]];
    
    [t addHeader:@"NSArray containsObject:"];
    [t addHeader:@"NSArray containsObject: best-case" withTimingInfo:[_results objectForKey:kfArrayContainsObjectBestCase]];
    [t addHeader:@"NSArray containsObject: worst-case" withTimingInfo:[_results objectForKey:kfArrayContainsObjectWorstCase]];
    
    [t addHeader:@"NSSet containsObject:"];
    [t addHeader:@"NSSet containsObject: best-case" withTimingInfo:[_results objectForKey:kfSetContainsObjectBestCase]];
    [t addHeader:@"NSSet containsObject: worst-case" withTimingInfo:[_results objectForKey:kfSetContainsObjectWorstCase]];
    
    [t addHeader:@"NSOrderedSet containsObject:"];
    [t addHeader:@"NSOrderedSet containsObject: best-case" withTimingInfo:[_results objectForKey:kfOrderedSetContainsObjectBestCase]];
    [t addHeader:@"NSOrderedSet containsObject: worst-case" withTimingInfo:[_results objectForKey:kfOrderedSetContainsObjectWorstCase]];
    
    [t addHeader:@"NSArray indexOfObject:"];
    [t addHeader:@"NSArray indexOfObject: best-case" withTimingInfo:[_results objectForKey:kfArrayIndexOfObjectBestCase]];
    [t addHeader:@"NSArray indexOfObject: worst-case" withTimingInfo:[_results objectForKey:kfArrayIndexOfObjectWorstCase]];
    
    [t addHeader:@"NSSet member:"];
    [t addHeader:@"NSSet member: best-case" withTimingInfo:[_results objectForKey:kfSetMemberBestCase]];
    [t addHeader:@"NSSet member: worst-case" withTimingInfo:[_results objectForKey:kfSetMemberWorstCase]];
    
    [t addHeader:@"NSOrderedSet indexOfObject:"];
    [t addHeader:@"NSOrderedSet indexOfObject: best-case" withTimingInfo:[_results objectForKey:kfOrderedSetIndexOfObjectBestCase]];
    [t addHeader:@"NSOrderedSet indexOfObject: worst-case" withTimingInfo:[_results objectForKey:kfOrderedSetIndexOfObjectWorstCase]];
    
    return [t description];
}

@end
