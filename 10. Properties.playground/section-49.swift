struct SomeStructure
{
	static var storedTypeProperty = "some value"
	
	// Here's a read-only computed type property using the short-hand read-only syntax
	static var computedTypeProperty: Int { return 4 }
}