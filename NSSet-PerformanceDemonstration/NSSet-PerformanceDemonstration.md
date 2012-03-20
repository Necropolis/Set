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

													Mean                  Variance           Standard Deviation
		NSMutableArray      unhinted best-case  addition
			MTU Timings:      4966576.611000          28153706829.345543      167790.663713
			Nanoseconds:      4966576.611000          28153706829.345543      167790.663713
		NSMutableSet        unhinted best-case  addition
			MTU Timings:     36579361.698000        1345524547895.363037     1159967.477085
			Nanoseconds:     36579361.698000        1345524547895.363037     1159967.477085
		NSMutableOrderedSet unhinted best-case  addition
			MTU Timings:     49027478.987000        1107627970662.163330     1052439.057933
			Nanoseconds:     49027478.987000        1107627970662.163330     1052439.057933
		NSMutableArray      hinted   best-case  addition
			MTU Timings:      5087746.041000          17873569894.239250      133692.071172
			Nanoseconds:      5087746.041000          17873569894.239250      133692.071172
		NSMutableSet        hinted   best-case  addition
			MTU Timings:     13836751.725000         175507692844.117188      418936.382813
			Nanoseconds:     13836751.725000         175507692844.117188      418936.382813
		NSMutableOrderedSet hinted   best-case  addition
			MTU Timings:     44414997.609000         495266768249.688660      703751.922377
			Nanoseconds:     44414997.609000         495266768249.688660      703751.922377
		NSMutableArray      unhinted worst-case addition
			MTU Timings:      6206868.904000         102202677475.406769      319691.534882
			Nanoseconds:      6206868.904000         102202677475.406769      319691.534882
		NSMutableSet        unhinted worst-case addition
			MTU Timings:     41893191.164000        5320320893917.540039     2306582.080464
			Nanoseconds:     41893191.164000        5320320893917.540039     2306582.080464
		NSMutableOrderedSet unhinted worst-case addition
			MTU Timings:     49753588.486000        4683516544232.943359     2164143.374232
			Nanoseconds:     49753588.486000        4683516544232.943359     2164143.374232
		NSMutableArray      hinted   worst-case addition
			MTU Timings:      6412381.680000         332730195301.001465      576827.699839
			Nanoseconds:      6412381.680000         332730195301.001465      576827.699839
		NSMutableSet        hinted   worst-case addition
			MTU Timings:     15077326.123000         559881051719.116333      748251.997471
			Nanoseconds:     15077326.123000         559881051719.116333      748251.997471
		NSMutableOrderedSet hinted   worst-case addition
			MTU Timings:     48759548.261000         828294120798.635254      910106.653529
			Nanoseconds:     48759548.261000         828294120798.635254      910106.653529
		NSArray containsObject: best-case
			MTU Timings: 139832745284.571442  2139454064901239296.000000  1462687275.155301
			Nanoseconds: 139832745284.571442  2139454064901239296.000000  1462687275.155301
		NSSet containsObject: best-case
			MTU Timings:      5649252.122000        1365940871820.187012     1168734.731160
			Nanoseconds:      5649252.122000        1365940871820.187012     1168734.731160
		NSOrderedSet containsObject: best-case
			MTU Timings:      9292549.384000        2340023262948.531738     1529713.457792
			Nanoseconds:      9292549.384000        2340023262948.531738     1529713.457792
		NSArray containsObject: worst-case
			MTU Timings: 155618338735.571442 28859317848661131264.000000  5372086917.452205
			Nanoseconds: 155618338735.571442 28859317848661131264.000000  5372086917.452205
		NSSet containsObject: worst-case
			MTU Timings:      5200489.963000         237334186555.898193      487169.566533
			Nanoseconds:      5200489.963000         237334186555.898193      487169.566533
		NSOrderedSet containsObject: worst-case
			MTU Timings:      8832241.763000         313431987810.158875      559849.969019
			Nanoseconds:      8832241.763000         313431987810.158875      559849.969019
		NSArray indexOfObject: best-case
			MTU Timings: 139911455159.857147  1618778888379401984.000000  1272312417.757290
			Nanoseconds: 139911455159.857147  1618778888379401984.000000  1272312417.757290
		NSSet member: best-case
			MTU Timings:      6827700.301000         145535892469.398010      381491.667628
			Nanoseconds:      6827700.301000         145535892469.398010      381491.667628
		NSOrderedSet indexOfObject: best-case
			MTU Timings:      9274930.575000         346534601588.511108      588671.896381
			Nanoseconds:      9274930.575000         346534601588.511108      588671.896381
		NSArray indexOfObject: worst-case
			MTU Timings: 152743756246.857147    90967073328678112.000000   301607482.216006
			Nanoseconds: 152743756246.857147    90967073328678112.000000   301607482.216006
		NSSet member: worst-case
			MTU Timings:      6688784.768000         149610441400.884033      386795.089680
			Nanoseconds:      6688784.768000         149610441400.884033      386795.089680
		NSOrderedSet indexOfObject: worst-case
			MTU Timings:      9081491.526000         357229775164.911316      597687.021078
			Nanoseconds:      9081491.526000         357229775164.911316      597687.021078

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