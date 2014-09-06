class Food
{
	var name: String

	// Designated initializer - required as the class does not have a default value for 'name'.
	// There can be more than one of these, but the fewer the better, usually, design-wise.
	init(name: String)
	{
		self.name = name
	}
	
	// Here, we'll use a convenience initializer to initialize 'name' to an unnamed Food
	convenience init()
	{
		// Must call the designated in same class
		self.init(name: "[unnamed]")
	}
}