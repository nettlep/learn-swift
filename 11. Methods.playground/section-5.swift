var counter = Counter()
counter.increment()
counter.incrementBy(4)
counter.addValueTo(value: 4)
counter.addTwiceWithExternalImplied(50, second: 4)
counter.addTwiceWithExternalSpecified(a: 50, b: 4)
counter.addTwiceWithExternalSpecified2(first: 10, second: 10)
counter.addTwiceWithExternalSpecified3(10, 10)
counter.count