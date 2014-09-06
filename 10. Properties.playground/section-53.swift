class SomeClass
{
	// The following line won't compile because classes aren't allowed stored type properties
	//
	// class var storedTypeProperty = "some value"
	
	// This is read-only, but you can also do read/write
	class var computedTypeProperty: Int { return 4 }
}