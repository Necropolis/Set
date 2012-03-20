//
//  TestObject.h
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property (assign) NSUInteger hash;
@property (strong) NSString * value;

+ (id)testObjectWithHash:(NSUInteger)hash value:(NSString *)value;

- (id)initWithHash:(NSUInteger)hash value:(NSString *)value;
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;

@end
