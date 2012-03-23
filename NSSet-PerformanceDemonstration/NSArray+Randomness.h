//
//  NSArray+Randomness.h
//  Set
//
//  Created by Christopher Miller on 3/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Randomness)

- (NSArray *)fs_arrayByShuffling;
- (NSArray *)fs_arrayWithNRandomObjects:(NSUInteger)n;

@end
