# NSSet Performance Demonstration

Times the performance of the key Foundation data containers: `NSArray`, `NSSet`, `NSOrderedSet`, and their mutable counterparts. It gathers several metrics based on a test set of `NSString` objects which are initialized like so:

		test string number 0
		test string number 1
		test string number ...
		test string number n

These strings are added to an array which forms the test data. Another array is later generated which is "shuffled" to present objects is a pseudorandom order. This serves to present data in a real-world scenario to `NSSet` and `NSOrderedSet` while also demonstrating the comparison-independent nature of `NSArray`.

Additionally, this random ordering is leveraged in the lookup tests to demonstrate the superiority of sets in finding objects.

## Results

All timings are in nanoseconds.

                           Mean                 Variance           Standard Deviation
    NSMutableArray addObject:
    NSMutableArray alloc/init addObject: best-case
      MTU Timings:     4847526.243000         62658632290.536789        250317.063523
      Nanoseconds:     4847526.243000         62658632290.536789        250317.063523
    NSMutableArray alloc/init addObject: worst-case
      MTU Timings:     6176854.339000        123803102772.761780        351856.650886
      Nanoseconds:     6176854.339000        123803102772.761780        351856.650886
    NSMutableArray alloc/initWithCapacity: addObject: best-case
      MTU Timings:     4729664.386000         48374679306.886932        219942.445442
      Nanoseconds:     4729664.386000         48374679306.886932        219942.445442
    NSMutableArray alloc/initWithCapacity: addObject: worst-case
      MTU Timings:     6035524.363000        167742585652.949799        409563.896911
      Nanoseconds:     6035524.363000        167742585652.949799        409563.896911
    NSMutableSet addObject:
    NSMutableSet alloc/init addObject: best-case
      MTU Timings:    33515276.151000        891687838330.846069        944292.242016
      Nanoseconds:    33515276.151000        891687838330.846069        944292.242016
    NSMutableSet alloc/init addObject: worst-case
      MTU Timings:    37553785.610000       4907560137896.626953       2215301.365028
      Nanoseconds:    37553785.610000       4907560137896.626953       2215301.365028
    NSMutableSet alloc/initWithCapacity: addObject: best-case
      MTU Timings:    12512076.514000        871029697535.791870        933289.717899
      Nanoseconds:    12512076.514000        871029697535.791870        933289.717899
    NSMutableSet alloc/initWithCapacity: addObject: worst-case
      MTU Timings:    14663529.182000        404857157996.489258        636283.865894
      Nanoseconds:    14663529.182000        404857157996.489258        636283.865894
    NSMutableOrderedSet addObject:
    NSMutableOrderedSet alloc/init addObject: best-case
      MTU Timings:    42284630.265000      10604542558632.093750       3256461.662392
      Nanoseconds:    42284630.265000      10604542558632.093750       3256461.662392
    NSMutableOrderedSet alloc/init addObject: worst-case
      MTU Timings:    51993559.652000      20662523337537.390625       4545604.837372
      Nanoseconds:    51993559.652000      20662523337537.390625       4545604.837372
    NSMutableOrderedSet alloc/initWithCapacity: addObject: best-case
      MTU Timings:    43155027.548000       9237444561650.312500       3039316.462899
      Nanoseconds:    43155027.548000       9237444561650.312500       3039316.462899
    NSMutableOrderedSet alloc/initWithCapacity: addObject: worst-case
      MTU Timings:    58213938.297000      47863129686067.648438       6918318.414620
      Nanoseconds:    58213938.297000      47863129686067.648438       6918318.414620
    NSArray containsObject:
    NSArray containsObject: best-case
      MTU Timings:   585747371.217001    7063213045002111.000000      84042923.824687
      Nanoseconds:   585747371.217001    7063213045002111.000000      84042923.824687
    NSArray containsObject: worst-case
      MTU Timings:   738497402.965000   45538367800185216.000000     213397206.636322
      Nanoseconds:   738497402.965000   45538367800185216.000000     213397206.636322
    NSSet containsObject:
    NSSet containsObject: best-case
      MTU Timings:     8760600.238000         90721861479.100616        301200.699666
      Nanoseconds:     8760600.238000         90721861479.100616        301200.699666
    NSSet containsObject: worst-case
      MTU Timings:     8989204.578000        142119504192.599640        376987.405881
      Nanoseconds:     8989204.578000        142119504192.599640        376987.405881
    NSOrderedSet containsObject:
    NSOrderedSet containsObject: best-case
      MTU Timings:    20035175.481000        262760636436.451233        512601.830309
      Nanoseconds:    20035175.481000        262760636436.451233        512601.830309
    NSOrderedSet containsObject: worst-case
      MTU Timings:    20155129.499000        429527952862.425171        655383.821026
      Nanoseconds:    20155129.499000        429527952862.425171        655383.821026
    NSArray indexOfObject:
    NSArray indexOfObject: best-case
      MTU Timings:   616488576.723000     656483545668885.250000      25621934.854122
      Nanoseconds:   616488576.723000     656483545668885.250000      25621934.854122
    NSArray indexOfObject: worst-case
      MTU Timings:   602683088.204001   52604815634637568.000000     229357397.165728
      Nanoseconds:   602683088.204001   52604815634637568.000000     229357397.165728
    NSSet member: 
    NSSet member: best-case
      MTU Timings:    14975366.089000       2485613258072.474609       1576582.778693
      Nanoseconds:    14975366.089000       2485613258072.474609       1576582.778693
    NSSet member: worst-case
      MTU Timings:    15428009.029000       2856629839962.157715       1690156.750116
      Nanoseconds:    15428009.029000       2856629839962.157715       1690156.750116
    NSOrderedSet indexOfObject:
    NSOrderedSet indexOfObject: best-case
      MTU Timings:    22528021.750000       2321594311848.357422       1523677.889794
      Nanoseconds:    22528021.750000       2321594311848.357422       1523677.889794
    NSOrderedSet indexOfObject: worst-case
      MTU Timings:    24049592.150000       1394929704424.166016       1181071.422237
      Nanoseconds:    24049592.150000       1394929704424.166016       1181071.422237


What is to be gained by this?

1. Arrays are much faster at `addObject:`.
2. If you know the end size of the container, using `initWithCapacity:` is really smart.
3. Finding the location of a given object in an array takes a really really long time.
4. Finding the membership of an object in a set is essentially free.

Found on:

		OS: Mac OS X 10.7.3
		Hardware: iMac 21.5-inch, Mid 2011
		CPU: 2.8 GHz Intel Core i7 Sandy Bridge (quad-core)
		RAM: 12 GB 1333 MHz DDR3
		Graphics: AMD Radeon HD 6770M 512MB

Compiled with:

		> clang --version
		Apple clang version 3.0 (tags/Apple/clang-211.12) (based on LLVM 3.0svn)
		Target: x86_64-apple-darwin11.3.0
		Thread model: posix