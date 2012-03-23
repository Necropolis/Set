//
//  main.m
//  NSSet-PerformanceDemonstration
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Flags.h"
#import "HelpOutput.h"
#import "ProfileHarness.h"
#import "Console.h"

BOOL tagsFoundInArgs(NSSet *, NSString *, ...) NS_REQUIRES_NIL_TERMINATION;

int main(int argc, const char * argv[])
{
    
    srandomdev();
    
    @autoreleasepool {
        
        NSSet * args = [NSSet setWithArray:[[NSProcessInfo processInfo] arguments]];
        
        if (tagsFoundInArgs(args, @"help", nil)) {
            PrintLn(@"Possible arguments:\n");
            PrintLn(@"%@", helpOutput());
            
            return 0;
        }
        
        NSString * file = @"~/.NSSet-PerformanceDemonstrationResults-RELEASE.plist";
#ifdef DEBUG
        file = @"~/.NSSet-PerformanceDemonstrationResults-DEBUG.plist";
#endif
        
        ProfileHarness * p = [[ProfileHarness alloc] initWithFile:file];
        
        [p run]; // will block until all tests are done
        
        PrintLn(@"%@", p);
        
    }
    return 0;
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
