struct Color
{
	let red = 0.0, green = 0.0, blue = 0.0
	
	// This initializer will make use of automatically generated exernal names
	init(red: Double, green: Double, blue: Double)
	{
		self.red = red
		self.green = green
		self.blue = blue
	}
	
	// This initializer opts out by explicitly declaring external names with "_"
	init(_ red: Double, _ blue: Double)
	{
		self.red = red
		self.green = 0
		self.blue = blue
	}
}