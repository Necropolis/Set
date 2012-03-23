//
//  ProfileHarness.h
//  Set
//
//  Created by Christopher Miller on 3/21/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileHarness : NSObject

@property (strong) NSOperationQueue * concurrentProfiles;
@property (strong) NSMutableDictionary * results;
@property (strong) NSString * cachedResults;
@property (assign) NSUInteger testDataSize;
@property (assign) NSUInteger numberOfTests;

- (id)initWithFile:(NSString *)filename;

- (void)run;

@end
