struct Point3
{
	var x = 0
	
	// This does not work with classes
	mutating func replaceMe(newX: Int)
	{
		self = Point3(x: 3)
	}
}