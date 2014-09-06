class Counter
{
	var count = 0;
	
	// No parameters
	func increment()
	{
		count++
	}
	
	// One parameter, no external parameter name needed by caller
	func incrementBy(amount: Int)
	{
		count += amount
	}
	
	// One parameter, overriding default behavior to requre caller to use external parameter name
	// on first (and only) parameter
	func addValueTo(value amount: Int)
	{
		count += amount
	}
	
	// Two parameters. Since no external names are specified, default behavior is implied: Caller
	// need not specify the first parameter's external name, but must specify all others:
	func addTwiceWithExternalImplied(first: Int, second: Int)
	{
		count += first
		count += second
	}
	
	// Two parameters. Using explicit external parameter names on all parameters to force caller
	// to use them for all parameters, including the first.
	func addTwiceWithExternalSpecified(a first: Int, b second: Int)
	{
		count += first
		count += second
	}
	
	// Two parameters. Using the external parameter shorthand ("#") to force caller to use
	// external parameter name on first parameter and defaulting to shared local/external names
	// for the rest.
	func addTwiceWithExternalSpecified2(#first: Int, second: Int)
	{
		count += first
		count += second
	}
	
	// Two parameters. Disabling all external names
	func addTwiceWithExternalSpecified3(first: Int, _ second: Int)
	{
		count += first
		count += second
	}
}