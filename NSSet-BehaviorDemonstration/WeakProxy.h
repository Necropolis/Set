//
//  WeakProxy.h
//  Set
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property (weak) id object;

+ (id)weakProxyWithObject:(id)object;
- (id)initWithObject:(id)object;

@end
