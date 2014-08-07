// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Properties store values in classes, structures and enumerations.
// ------------------------------------------------------------------------------------------------

// Here's a structure with a couple simple stored properties:
struct FixedLengthRange
{
	var firstValue: Int
	let length: Int
}

// Structures must have all of their properties initialized upon instantiation.
//
// This won't compile since the struct includes properties that havn't been initialized with
// default values:
//
// var anotherRangeOfThreeItems = FixedLengthRange()
//
// In order to instantiate a FixedLengthRange struct, we must use the memberwise initializer. Note
// that this will initialize a constant property and a variable property inside the struct:
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6

// ------------------------------------------------------------------------------------------------
// Lazy Stored Properties
//
// A Lazy Stored Property is a value that is not calculated until its first use.
//
// They are declared using the "lazy" attribute and may not be constant.
//
// Global and local variables are all lazy, except that they don't need the lazy attribute.
//
// Here, we'll define a couple classes to showcase Lazy Stored Properties. In this example, let's
// assume that DataImporter is a time-consuming process, and as such, we will want to use a lazy
// stored property whenever we use it. This way, if we end up never using it, we never pay the
// penalty of instantiating it.
class DataImporter
{
	var filename = "data.txt"
}

class DataManager
{
	lazy var importer = DataImporter()
	var data = [String]()
}

// Now let's instantiate the data manager and add some simple data to the class:
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")

// Notice how we haven't used the importer yet, so it is nil:
manager

// So now let's access it:
manager.importer.filename

// And now we see the importer was created:
manager

// ------------------------------------------------------------------------------------------------
// Computed Properties
//
// Computed properties don't store data, but rather use getters and setters for accessing values
// that are computed up on request.
//
// Computed Properties are available for global as well as local variables.
//
// We'll start with a few structures that we'll use to show how computed properties work.
struct Point
{
	var x = 0.0, y = 0.0
}
struct Size
{
	var width = 0.0, height = 0.0
}

// The following structure includes a computed property with a Point type named 'center'. Notice
// that 'center' is variable (not constant) which is a requirement of computed properties.
//
// Every computed property must have a getter, but does not need a setter. If we provide a setter,
// we need to know the new value being assigned to the computed property. We've called this
// value 'newCenter'. Note that this value does not have a type annotation because the computed
// property already knows that it is a Point type. Providing a type annotation would be an error.
struct Rect
{
	var origin = Point()
	var size = Size()
	var center: Point
	{
		get
		{
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set(newCenter)
		{
			origin.x = newCenter.x - (size.width / 2)
			origin.y = newCenter.y - (size.height / 2)
		}
	}
}

// Here, we'll create a square from our Rect structure
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))

// We can now get the center point, computed from the Rect's origin and size. Being a computed
// property, we can treat it just like any other peroperty.
let initialSquareCenter = square.center

// Since we provided a setter, we can also set the center point as if it is a stored property.
// This will effectively update the Rect's origin and size based on the specified center point.
square.center = Point(x: 15, y: 15)

// We can see that the origin has been updated from (0, 0) to (10, 10):
square.origin

// Shorthand Setter Declaration
//
// The computed property's setter from the Rect structure provided a parameter on the setter named
// 'newCenter'. If we don't specify this parameter, Swift will automatically generate an input
// value named 'newValue' for us.
//
// Here, AlternativeRect is the same declaration as Rect above, except that the setter uses
// Swift's default setter value, 'newValue':
struct AlternativeRect
{
	var origin = Point()
	var size = Size()
	var center: Point
	{
		get
		{
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set
		{
			origin.x = newValue.x - (size.width / 2)
			origin.y = newValue.y - (size.height / 2)
		}
	}
}

// We can also have a read-only computed property by simply omitting the setter:
struct Cube
{
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double
	{
		get
		{
			return width * height * depth
		}
	}
}

// Alternatively, Swift allows us to shorten the syntax of a read-only computed property by
// omitting the get{} construct and inserting the code for the getter directly into the property
// declaration:
struct AnotherCube
{
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double
	{
		return width * height * depth
	}
}

// Let's declare our structure and read the 'volume' property
var cube = AnotherCube(width: 4, height: 5, depth: 2)
cube.volume

// Since the 'volume' property is read-only, if we tried to assign a value to it, it would
// would generate a compiler error.
//
// The following line of code will not compile:
//
// cube.volume = 8.0

// ------------------------------------------------------------------------------------------------
// Property Observers
//
// Property observers allow us to respond to changes in a property's value. We can declare an
// observer that contains our code that is run just before a property is set (optionally allowing
// us to alter the value being set) and an observer that is run just after a property has been
// modified.
//
// Property observers are available for global as well as local variables.
//
// These observers are not called when a property is first initialized, but only when it changes.
//
// Similar to setters, each 'willSet' and 'didSet' will receive a parameter that represents (in 
// the case of 'willSet') the value about to be assigned to the property and (in the case of
// 'didSet') the value that was previously stored in the property prior to modification.
class StepCounter
{
	var totalSteps: Int = 0
	{
		willSet(newTotalSteps)
		{
			"About to step to \(newTotalSteps)"
		}
		didSet(oldTotalSteps)
		{
			"Just stepped from \(oldTotalSteps)"
		}
	}
}

// Let's create an instance of StepCounter so we can try out our observer
let stepCounter = StepCounter()

// The following will first call 'willSet' on the 'totalSteps' property, followed by a change to
// the value itself, followed by a call to 'didSet'
stepCounter.totalSteps = 200;

// Similar to setters, we can shorten our observers by omitting the parameter list for each. When
// we co this, Swift automatically provides parameters named 'newValue' and 'oldValue'
class StepCounterShorter
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { "Just stepped from \(oldValue)" }
	}
}

// We can also override the value being set by modifying the property itself within the 'didSet'
// observer. This only works in the 'didSet'. If you attempt to modify the property in 'willSet'
// you will receive a compiler warning.
//
// Let's try wrapping our value to the range of 0...255
class StepCounterShorterWithModify
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { totalSteps = totalSteps & 0xff }
	}
}
var stepper = StepCounterShorterWithModify()
stepper.totalSteps = 345
stepper.totalSteps // This reports totalSteps is now set to 89

// ------------------------------------------------------------------------------------------------
// Type Properties
//
// Until now, we've been working with Instance Properties and Instance Methods, which are
// associated to an instance of a class, structure or enumeration. Each instance gets its own copy
// of the property or method.
//
// Type properties are properties that are attached to the class, structure or enumeration's type
// itself and not any specific instance. All instances of a type will share the same Type Property.
//
// These are similar to 'static' properties in C-like languages.
//
// For Value types (structs, enums) we use the 'static' keyword. For Class types with the 'class'
// keyword.
//
// Type properties can be in the form of stored properties or computed properties. As with normal
// stored or computed properties, all the same rules apply except that stored type properties must
// always have a default value. This exception is necessary because the initializer (which we'll
// learn about later) is associated to a specific instance and as such, cannot be reliable for
// initializing type properties.
//
// Here is a class with a couple of type properties
struct SomeStructure
{
	static var storedTypeProperty = "some value"
	
	// Here's a read-only computed type property using the short-hand read-only syntax
	static var computedTypeProperty: Int { return 4 }
}

// Similarly, here's an enumeration with a couple of type properties
enum SomeEnum
{
	static let storedTypeProperty = "some value"
	
	static var computedTypeProperty: Int { return 4 }
}

// Classes are a little different in that they cannot contain stored type properties, but may
// only contain computed type properties
class SomeClass
{
	// The following line won't compile because classes aren't allowed stored type properties
	//
	// class var storedTypeProperty = "some value"
	
	// This is read-only, but you can also do read/write
	class var computedTypeProperty: Int { return 4 }
}

