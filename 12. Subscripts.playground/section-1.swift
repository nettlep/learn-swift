struct TimesTable
{
	let multiplier: Int
	
	// Read-only subscript using simplified getter syntax
	subscript(index: Int) -> Int
	{
		return multiplier * index
	}

	// Overloaded subscript for type Double, also read-only using the simplified getter syntax
	subscript(index: Double) -> Int
	{
		return multiplier * Int(index)
	}
}