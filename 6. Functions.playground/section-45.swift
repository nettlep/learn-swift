func yetAnotherArithmeticMean(initialTotal: Double = 0, values numbers: Double...) -> Double
{
	var total = initialTotal
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}