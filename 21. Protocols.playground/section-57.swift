@objc class Counter
{
	var count = 0
	var dataSource: CounterDataSource?
	func increment()
	{
		// Does the dataSource conform to the incrementForCount method?
		if let amount = dataSource?.incrementForCount?(count)
		{
			count += amount
		}
		// If not, does it conform to the fixedIncrement variable requirement?
		else if let amount = dataSource?.fixedIncrement?
		{
			count += amount
		}
	}
}