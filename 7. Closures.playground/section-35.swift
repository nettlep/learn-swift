func makeIncrementor(forIncrement amount: Int) -> () -> Int
{
	var runningTotal = 0
	
	// runningTotal and amount are 'captured' for the nested function incrementor()
	func incrementor() -> Int
	{
		runningTotal += amount
		return runningTotal
	}

	// We return the nested function, which has captured it's environment
	return incrementor
}