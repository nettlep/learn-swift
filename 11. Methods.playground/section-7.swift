class Point
{
	var x: Int = 10
	
	func setX(x: Int)
	{
		// Using self to disambiguate from the local parameter
		self.x = x
	}
}