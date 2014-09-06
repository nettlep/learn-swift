func anotherArithmeticMean(initialTotal: Double = 0, numbers: Double...) -> Double
{
	var total = initialTotal
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}