//
//  HelpOutput.m
//  Set
//
//  Created by Christopher Miller on 3/21/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import "HelpOutput.h"

#import "Flags.h"
#import "ASCIITable.h"

@interface ASCIITable (HelpOutput)
- (void)addHelpFlag:(NSString *)flag description:(NSString *)description;
@end

NSString * helpOutput()
{
    ASCIITable * t = [[ASCIITable alloc] init];
    t.spacesBetweenColumns = 2;
    
    [t addHelpFlag:kfAll                                description:@"all tests (takes a while)"];
    
    [t addHelpFlag:kfArrayAdd                           description:@"all array addition tests"];
    [t addHelpFlag:kfArrayAddHintless                   description:@"all hintless array addition tests"];
    [t addHelpFlag:kfArrayAddHintlessBestCase           description:@"best-case hintless array addition test"];
    [t addHelpFlag:kfArrayAddHintlessWorstCase          description:@"worst-case hintless array addition test"];
    [t addHelpFlag:kfArrayAddHinted                     description:@"all hinted array addition tests"];
    [t addHelpFlag:kfArrayAddHintedBestCase             description:@"best-case hinted array addition test"];
    [t addHelpFlag:kfArrayAddHintedWorstCase            description:@"worst-case hinted array addition test"];
    
    [t addHelpFlag:kfSetAdd                             description:@"all set addition tests"];
    [t addHelpFlag:kfSetAddHintless                     description:@"all hintless set addition tests"];
    [t addHelpFlag:kfSetAddHintlessBestCase             description:@"best-case hintless set addition test"];
    [t addHelpFlag:kfSetAddHintlessWorstCase            description:@"worst-case hintless set addition test"];
    [t addHelpFlag:kfSetAddHinted                       description:@"all hinted set addition tests"];
    [t addHelpFlag:kfSetAddHintedBestCase               description:@"best-case hinted set addition test"];
    [t addHelpFlag:kfSetAddHintedWorstCase              description:@"worst-case hinted set addition test"];
    
    [t addHelpFlag:kfOrderedSetAdd                      description:@"all ordered set addition tests"];
    [t addHelpFlag:kfOrderedSetAddHintless              description:@"all hintless ordered set addition tests"];
    [t addHelpFlag:kfOrderedSetAddHintlessBestCase      description:@"best-case hintless ordered set addition test"];
    [t addHelpFlag:kfOrderedSetAddHintlessWorstCase     description:@"worst-case hintless ordered set addition tests"];
    [t addHelpFlag:kfOrderedSetAddHinted                description:@"all hinted ordered set addition tests"];
    [t addHelpFlag:kfOrderedSetAddHintedBestCase        description:@"best-case hinted ordered set addition test"];
    [t addHelpFlag:kfOrderedSetAddHintedWorstCase       description:@"worst-case hinted ordered set addition test"];
    
    [t addHelpFlag:kfArrayContainsObject                description:@"all array containsObject: lookup tests (very very very long)"];
    [t addHelpFlag:kfArrayContainsObjectBestCase        description:@"best-case array containsObject: lookup test (very long)"];
    [t addHelpFlag:kfArrayContainsObjectWorstCase       description:@"worst-case array containsObject: lookup test (very very long)"];
    
    [t addHelpFlag:kfSetContainsObject                  description:@"all set containsObject: lookup tests"];
    [t addHelpFlag:kfSetContainsObjectBestCase          description:@"best-case set containsObject: lookup test"];
    [t addHelpFlag:kfSetContainsObjectWorstCase         description:@"worst-case set containsObject: lookup test"];
    
    [t addHelpFlag:kfOrderedSetContainsObject           description:@"all ordered set containsObject: lookup tests"];
    [t addHelpFlag:kfOrderedSetContainsObjectBestCase   description:@"best-case ordered set containsObject: lookup test"];
    [t addHelpFlag:kfOrderedSetContainsObjectWorstCase  description:@"worst-case ordered set containsObject: lookup test"];
    
    [t addHelpFlag:kfArrayIndexOfObject                 description:@"all array indexOfObject: lookup tests (very very very long)"];
    [t addHelpFlag:kfArrayIndexOfObjectBestCase         description:@"best-case array indexOfObject: lookup test (very long)"];
    [t addHelpFlag:kfArrayIndexOfObjectWorstCase        description:@"worst-case array indexOfObject: lookup test (very very long)"];
    
    [t addHelpFlag:kfSetMember                          description:@"all set member: lookup tests"];
    [t addHelpFlag:kfSetMemberBestCase                  description:@"best-case set member: lookup test"];
    [t addHelpFlag:kfSetMemberWorstCase                 description:@"worst-case set member: lookup test"];
    
    [t addHelpFlag:kfOrderedSetIndexOfObject            description:@"all ordered set indexOfObject: lookup tests"];
    [t addHelpFlag:kfOrderedSetIndexOfObjectBestCase    description:@"best-case ordered set indexOfObject: lookup test"];
    [t addHelpFlag:kfOrderedSetIndexOfObjectWorstCase   description:@"worst-case ordered set indexOfObject: lookup test"];
    
    return [t description];
}

@implementation ASCIITable (HelpOutput)

- (void)addHelpFlag:(NSString *)flag description:(NSString *)description
{
    [self addRow];
    [self addString:flag withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
    [self addString:description withAlign:kLeft colSpan:1 shouldIgnoreWidth:NO];
}

@end