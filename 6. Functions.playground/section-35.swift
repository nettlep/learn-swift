func arithmeticMean(numbers: Double...) -> Double
{
	var total = 0.0
	
	// The variadic, numbers, looks like an array to the internal function so we can just loop
	// through them
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}