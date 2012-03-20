//
//  TestObject.m
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

@synthesize hash=_hash;
@synthesize value=_value;

+ (id)testObjectWithHash:(NSUInteger)hash value:(NSString *)value
{
    return [[[self class] alloc] initWithHash:hash value:value];
}

- (id)initWithHash:(NSUInteger)hash value:(NSString *)value
{
    self = [super init];
    if (self) {
        _hash = hash;
        _value = value;
    }
    return self;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [NSString stringWithFormat:@"%@<%@:%p hash:%lu value:%@>", [NSString fs_stringByFillingWithCharacter:' ' repeated:level*4], NSStringFromClass([self class]), self, _hash, [_value fs_stringByEscaping]];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
        return [_value isEqual:[object value]];
    else
        return NO;
}

- (NSString *)description
{
    return [self descriptionWithLocale:nil indent:0];
}

@end

