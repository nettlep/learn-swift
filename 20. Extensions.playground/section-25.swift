extension Int
{
	subscript(digitIndex: Int) -> Int
	{
		var decimalBase = 1
		for _ in 0 ..< digitIndex
		{
			decimalBase *= 10
		}
		return self / decimalBase % 10
	}
}