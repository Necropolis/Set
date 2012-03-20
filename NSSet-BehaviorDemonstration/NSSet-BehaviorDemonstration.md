# NSSet Behavior Demonstration

> This test demonstrates the core behavior of `NSSet`.

Objects are stored in a set if both their hashes are different and`isEqual:` is `NO`. For example, the following two test objects:

		> TestObject * obj1 = [TestObject testObjectWithHash:0x0001 value @"obj1"]
		 => <TestObject:0x10ab14b50 hash:1 value:obj1>
		> TestObject * obj2 = [TestObject testObjectWithHash:0x0002 value:@"obj2"]
		 => <TestObject:0x10ab15090 hash:2 value:obj2>

When placed in a set, they show as unique because their hashes aredifferent and they are not equal to each other.

		> NSSet * s1 = [NSSet setWithObjects:obj1, obj2, nil]
		 =>     {(
								<TestObject:0x10ab14b50 hash:1 value:obj1>,
								<TestObject:0x10ab15090 hash:2 value:obj2>
		)}

If we change the `hash` for one object, they will still be consideredunique, as shown when they are added to this new set.

		> obj2.hash = obj1.hash
		 => <TestObject:0x10ab15090 hash:1 value:obj2>
		> s1 = [NSSet setWithObjects:obj1, obj2, nil]
		 =>     {(
								<TestObject:0x10ab14b50 hash:1 value:obj1>,
								<TestObject:0x10ab15090 hash:1 value:obj2>
		)}

What happens when we start playing with `isEqual:`? Let's reset thehashes to be different, then make it so that `obj2` thinks that `obj1`is equal to itself.

		> obj2.hash = 0x0002
		 => <TestObject:0x10ab15090 hash:2 value:obj2>
		> obj2.value = obj1.value
		 => <TestObject:0x10ab15090 hash:2 value:obj1>
		> s1 = [NSSet setWithObjects:obj1, obj2, nil]
		 =>     {(
								<TestObject:0x10ab14b50 hash:1 value:obj1>,
								<TestObject:0x10ab15090 hash:2 value:obj1>
		)}

Now that their hashes are different, but `obj2` thinks it's equal to
`obj1`, let's see what `containsObject:` says.

		> [s1 containsObject:obj1]
		 => YES
		> [s1 containsObject:obj2]
		 => YES

`member:` is another tool, which returns the object from the set.

		> obj1
		 => <TestObject:0x10ab14b50 hash:1 value:obj1>
		> [s1 member:obj1]
		 => <TestObject:0x10ab14b50 hash:1 value:obj1>
		> obj2
		 => <TestObject:0x10ab15090 hash:2 value:obj1>
		> [s1 member:obj2]
		 => <TestObject:0x10ab15090 hash:2 value:obj1>

`NSSet` is looking up the object based on `hash`. This is easy enough to prove.

		> obj1 = [TestObject testObjectWithHash:0x0001 value:@"value1"]
		 => <TestObject:0x10ab19f50 hash:1 value:value1>
		> obj2 = [TestObject testObjectWithHash:0x0002 value:@"value2"]
		 => <TestObject:0x10ab19520 hash:2 value:value2>
		> obj3 = [TestObject testObjectWithHash:0x0002 value:@"value1"]
		 => <TestObject:0x10ab1a2d0 hash:2 value:value1>
		> s1 = [NSSet setWithObjects:obj1, obj2, nil]
		 =>     {(
								<TestObject:0x10ab19f50 hash:1 value:value1>,
								<TestObject:0x10ab19520 hash:2 value:value2>
		)}
		> [s1 member:obj1]
		 => <TestObject:0x10ab19f50 hash:1 value:value1>
		> [s1 member:obj2]
		 => <TestObject:0x10ab19520 hash:2 value:value2>
		> [s1 member:obj3]
		 => (null)
		> obj3.hash = 0x0001
		 => <TestObject:0x10ab1a2d0 hash:1 value:value1>
		> [s1 member:obj3]
		 => <TestObject:0x10ab19f50 hash:1 value:value1>

A careful reading of the documentation for the `NSObject` protocol says thatif two objects are equal, their `hash` must be equal as well. While within acollection the `hash` must not change. This is a little tricky formutable objects, but can pay some dividends on lookup times.

Suppose you have a large number of objects, and you need to determine ifyou have already encountered this object before. If the object is quitesmall, then the cost to create it is small. Store the already-encounteredobjects in a set, then create that new temporary (and possibly duplicate)object. Then, check to see that it's in the set. It's significantly fasterthan `NSArray`'s `containsObject:` implementation. `member:` returns the objectfrom the set, so if there's other data on that object which doesn't alter the`hash` value, you can safely modify that object in the set, throwing awaythe temporary object.
