//
//  NSArray+Randomness.m
//  Set
//
//  Created by Christopher Miller on 3/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "NSArray+Randomness.h"

NSUInteger randomUnder(NSUInteger);

@implementation NSArray (Randomness)

- (NSArray *)fs_arrayByShuffling
{
    return [self fs_arrayWithNRandomObjects:[self count]];
}

- (NSArray *)fs_arrayWithNRandomObjects:(NSUInteger)n
{
    NSMutableArray * randomObjects = [[NSMutableArray alloc] initWithCapacity:n];
    NSMutableIndexSet * usedIndices = [[NSMutableIndexSet alloc] init];
    NSUInteger self_count = [self count];
    NSUInteger idx = randomUnder(self_count);
    for (NSUInteger i = 0;
         i < n;
         ++i) {
        while ([usedIndices containsIndex:idx])
            idx = randomUnder(self_count);
        [randomObjects addObject:[self objectAtIndex:idx]];
        [usedIndices addIndex:idx];
    }
    return [randomObjects copy];
}

@end

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
