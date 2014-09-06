struct Point2
{
	var x: Int = 10

	// Note the need for the keyword 'mutating'
	mutating func setX(x: Int)
	{
		self.x = x
	}
}