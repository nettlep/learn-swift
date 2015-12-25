// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Swift provides an initializer (which partially resembles a function) to ensure that every
//   property in a class, structure or enumeration is fully initialized.
//
// * Optionals do not need to be initialized as they are automatically initialized to nil if no
//   default value is provided.
// ------------------------------------------------------------------------------------------------

// Here's a basic use of an initializer.
//
// The Fahrenheit class will create a 'temperature' property that does not have a default value.
// Because there is no default value, the property must be initialized in the initializer.
//
// Without the initializer, we would get an error whenever we tried to instantiate the Fahrenheit
// class.
struct Fahrenheit
{
	var temperature: Double

	init()
	{
		temperature = 32.0
	}
}

// Since the class can fully initialize itself, we can safely instantiate it with no error:
var f = Fahrenheit()

// Since the temperature is always defined as "32.0", it is cleaner and preferred to use a default
// value instead of setting it inside the initializer:
struct AnotherFahrenheit
{
	var temperature: Double = 32.0
}

// Initializers can also include parameters. Here's an example of using a parameter to initialize
// the class's temperature to a given value.
//
// The following class contains two initializers:
struct Celsius
{
	var temperatureInCelsius: Double = 0.0
	
	// Initialize our temperature from Fahrenheit
	init(fromFahrenheit fahrenheit: Double)
	{
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8
	}
	
	// Initialize our temperature from Kelvin
	init(kelvin: Double)
	{
		temperatureInCelsius = kelvin - 273.15
	}
}

// Now let's try our new initializers
let boilingPotOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(kelvin: 273.15)

// External parameter names are automatically generated for the initializer. In order to opt-out
// of this automated convenience, you can specify "_" for the extnenal name explicitly.
//
// Here's a class that defines two initializers - one that makes use of the automatic external
// name generation and one that opts out:
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

// Here, we can see our efforts pay off:
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let purple = Color(1.0, 0.5)

// Optional properties do not need to be initialized:
class SurveyQuestion
{
	var text: String
	
	// Response is optional, and is automatically initialized to nil
	var response: String?

	init(text: String)
	{
		// We only need to initialize 'text'
		self.text = text
	}
	
	func ask() -> String
	{
		return text
	}
}

// Constants need initialization as well. In the following example, our constant has a default
// value. However, if we initialize the class with the init(text: String) initializer, we can
// modify the default value to use the one passed in:
class SurveyQuestion2
{
	// Default value of "No question"
	let text: String = "No question"
	
	var response: String?
	
	init(text: String)
	{
		// Initializing the constant, 'text', even though it has a default value, we can modify
		// that default value here
		self.text = text
	}
	
	init()
	{
		// We do nothing here and let the default value for 'text' define its value
	}
	
	func ask() -> String
	{
		return text
	}
}

// Here, we initialize the class with a blank initializer (calling init()) to let text's default
// value initialize the stored value
let noQuestion = SurveyQuestion2()

// Here, we'll us an aalternat initializer to specify a different value for 'text'
let beetsQuestion = SurveyQuestion2(text: "Do you like beets?")

// ------------------------------------------------------------------------------------------------
// Default Initializer
//
// If all properties have default values (including optionals defaulting to nil) AND you do not
// create your own initlializer AND there is no superclass, Swift will create a default
// initializer (with no parameters) for you. This initializer sets all properties to their
// default values.
//
// If you create your own initializer, Swift will not create the default initializer. If you want
// your custom initializers as well as the default initializer, then put your initializers in an
// extension.
class ShoppingListItem
{
	var name: String?
	var quantity = 1
	var purchased = false
	
	// No init(...) initializer
}

// ------------------------------------------------------------------------------------------------
// Memberwise Initializers for Structure Types
//
// Similar to the default initializer for classes, structures that do not implement an initializer
// but have default values for their stored properties will get a default memberwise initializer.
//
// As with classes, if you want your custom initializers as well as the default memberwise
// initializer, then put your initializers in an extension.
struct Size
{
	var width = 0.0
	var height = 0.0
}

// Here, we call the default memberwise initializer that Swift created for us
let twoByTwo = Size(width: 2.0, height: 2.0)

// ------------------------------------------------------------------------------------------------
// Initializer Delegatgion for Value Types
//
// Sometimes, it's convenient to have multiple initializers that call other initializers to do
// some of the heavy lifting.
//
// In the following example, we have a class 'Rect' that has multiple initializers. One that
// initializes our rect given an origin and size, while another that calls upon the origin/size
// initializer from calculations based on the a center point.
//
// This concept is further extended in "Initializer Chaining", covered later.
struct Point
{
	var x = 0.0
	var y = 0.0
}

struct Rect
{
	var origin = Point()
	var size = Size()
	
	// We create a basic initializer to use the default values Since we define other initializers,
	// the system won't create this for us, so we need to define it ourselves. Since we're using
	// the defaults, it is an empty closure.
	init() {}
	
	// Init from origin/size
	init(origin: Point, size: Size)
	{
		self.origin = origin
		self.size = size
	}
	
	// Init from center/size - note how we use the init(origin:size) to  perform actual
	// initialization
	init(center: Point, size: Size)
	{
		let originX = center.x - size.width / 2
		let originY = center.y - size.height / 2
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}

// Here, we call the three initializers:
let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
