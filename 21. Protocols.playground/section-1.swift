protocol someProtocolForProperties
{
	// A read/write property
	var mustBeSettable: Int { get set }
	
	// A read-only property
	var doesNotNeedToBeSettable: Int { get }
	
	// A type property always uses 'class'. This is the case even if adopted by a structure or
	// enumeration which will use 'static' when conforming to the protocol's property.
	class var someTypeProperty: Int { get set }
}