//
//  main.m
//  NSSet-BehaviorDemonstration
//
//  Created by Christopher Miller on 3/20/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestObject.h"
#import "Console.h"
#import "NSContainers+DebugPrint.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // 1. Test that objects are stored based on the uniqueness of their hash and isEqual:
        PrintLn(@"Objects are stored in a set if both their hashes are different and"
                @"`isEqual:` is `NO`. For example, the following two test objects:\n");
        TestObject * obj1, * obj2;
        obj1 = [TestObject testObjectWithHash:0x0001 value:@"obj1"];
        obj2 = [TestObject testObjectWithHash:0x0002 value:@"obj2"];
        PrintLn(@"    > TestObject * obj1 = [TestObject testObjectWithHash:0x0001 value @\"obj1\"]\n"
                @"     => %@\n"
                @"    > TestObject * obj2 = [TestObject testObjectWithHash:0x0002 value:@\"obj2\"]\n"
                @"     => %@\n", obj1, obj2);
        PrintLn(@"When placed in a set, they show as unique because their hashes are"
                @"different and they are not equal to each other.\n");
        NSSet * s1 = [NSSet setWithObjects:obj1, obj2, nil];
        PrintLn(@"    > NSSet * s1 = [NSSet setWithObjects:obj1, obj2, nil]\n"
                @"     => %@\n", [s1 descriptionWithLocale:nil indent:1]);
        PrintLn(@"If we change the `hash` for one object, they will still be considered"
                @"unique, as shown when they are added to this new set.\n");
        obj2.hash = obj1.hash;
        s1 = [NSSet setWithObjects:obj1, obj2, nil];
        PrintLn(@"    > obj2.hash = obj1.hash\n"
                @"     => %@\n"
                @"    > s1 = [NSSet setWithObjects:obj1, obj2, nil]\n"
                @"     => %@\n", obj2, [s1 descriptionWithLocale:nil indent:1]);
        PrintLn(@"What happens when we start playing with `isEqual:`? Let's reset the"
                @"hashes to be different, then make it so that `obj2` thinks that `obj1`"
                @"is equal to itself.\n");
        obj2.hash = 0x0002;
        PrintLn(@"    > obj2.hash = 0x0002\n"
                @"     => %@", obj2);
        obj2.value = obj1.value;
        PrintLn(@"    > obj2.value = obj1.value\n"
                @"     => %@", obj2);
        s1 = [NSSet setWithObjects:obj1, obj2, nil];
        PrintLn(@"    > s1 = [NSSet setWithObjects:obj1, obj2, nil]\n"
                @"     => %@\n", [s1 descriptionWithLocale:nil indent:1]);
        // 2. Test that containsObject: returns whichever object isEqual: returns YES to
        PrintLn(@"Now that their hashes are different, but `obj2` thinks it's equal to\n"
                @"`obj1`, let's see what `containsObject:` says.\n");
        PrintLn(@"    > [s1 containsObject:obj1]\n"
                @"     => %@", [s1 containsObject:obj1]?@"YES":@"NO");
        PrintLn(@"    > [s1 containsObject:obj2]\n"
                @"     => %@\n", [s1 containsObject:obj2]?@"YES":@"NO");
        PrintLn(@"`member:` is another tool, which returns the object from the set.\n");
        PrintLn(@"    > obj1\n"
                @"     => %@\n"
                @"    > [s1 member:obj1]\n"
                @"     => %@\n"
                @"    > obj2\n"
                @"     => %@\n"
                @"    > [s1 member:obj2]\n"
                @"     => %@\n", obj1, [s1 member:obj1], obj2, [s1 member:obj2]);
        PrintLn(@"`NSSet` is looking up the object based on `hash`. This is easy enough to prove.\n");
        TestObject * obj3;
        obj1 = [TestObject testObjectWithHash:0x0001 value:@"value1"];
        obj2 = [TestObject testObjectWithHash:0x0002 value:@"value2"];
        obj3 = [TestObject testObjectWithHash:0x0002 value:@"value1"];
        s1 = [NSSet setWithObjects:obj1, obj2, nil];
        PrintLn(@"    > obj1 = [TestObject testObjectWithHash:0x0001 value:@\"value1\"]\n"
                @"     => %@\n"
                @"    > obj2 = [TestObject testObjectWithHash:0x0002 value:@\"value2\"]\n"
                @"     => %@\n"
                @"    > obj3 = [TestObject testObjectWithHash:0x0002 value:@\"value1\"]\n"
                @"     => %@", obj1, obj2, obj3);
        PrintLn(@"    > s1 = [NSSet setWithObjects:obj1, obj2, nil]\n"
                @"     => %@", [s1 descriptionWithLocale:nil indent:1]);
        PrintLn(@"    > [s1 member:obj1]\n"
                @"     => %@\n"
                @"    > [s1 member:obj2]\n"
                @"     => %@\n"
                @"    > [s1 member:obj3]\n"
                @"     => %@", [s1 member:obj1], [s1 member:obj2], [s1 member:obj3]);
        obj3.hash = 0x0001;
        PrintLn(@"    > obj3.hash = 0x0001\n"
                @"     => %@\n"
                @"    > [s1 member:obj3]\n"
                @"     => %@\n", obj3, [s1 member:obj3]);
        PrintLn(@"A careful reading of the documentation for the `NSObject` protocol says that"
                @"if two objects are equal, their `hash` must be equal as well. While within a"
                @"collection the `hash` must not change. This is a little tricky for"
                @"mutable objects, but can pay some dividends on lookup times.\n");
        PrintLn(@"Suppose you have a large number of objects, and you need to determine if"
                @"you have already encountered this object before. If the object is quite"
                @"small, then the cost to create it is small. Store the already-encountered"
                @"objects in a set, then create that new temporary (and possibly duplicate)"
                @"object. Then, check to see that it's in the set. It's significantly faster"
                @"than `NSArray`'s `containsObject:` implementation. `member:` returns the object"
                @"from the set, so if there's other data on that object which doesn't alter the"
                @"`hash` value, you can safely modify that object in the set, throwing away"
                @"the temporary object.\n");
        
    }
    return 0;
}


