extension Int
{
	mutating func square()
	{
		self = self * self
	}
}

var someInt = 3
someInt.square() // someInt is now 9