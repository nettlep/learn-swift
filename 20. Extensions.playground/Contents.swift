// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Similar to Objective-C categories, extensions allow you to add functionality to an existing
//   type (class, struct, enumeration.)
//
// * You do not need access to the original source code to extend a type.
//
// * Extensions can be applied to built-in types as well, including String, Int, Double, etc.
//
// * With extensions, you can:
//
//   o Add computed properties (including static)
//   o Define instance methods and type methods
//   o Provide new convenience initializers
//   o Define subscripts
//   o Define and use new nested types
//   o Make an existing type conform to a protocol
//
// * Extensions do not support adding stored properties or property observers to a type.
//
// * Extensions apply all instances of a type, even if they were created before the extension was
//   defined.
// ------------------------------------------------------------------------------------------------

// Let's take a look at how extensions are declared. Note that, unlike Objective-C categories,
// extensions are not named:
extension Int
{
	// ... code here
}

// ------------------------------------------------------------------------------------------------
// Computed properties
//
// Computed properties are a poweful use of extensions. Below, we'll add native conversion from
// various measurements (Km, mm, feet, etc.) to the Double class.
extension Double
{
	var kmToMeters: Double { return self * 1_000.0 }
	var cmToMeters: Double { return self / 100.0 }
	var mmToMeters: Double { return self / 1_000.0 }
	var inchToMeters: Double { return self / 39.3701 }
	var ftToMeters: Double { return self / 3.28084 }
}

// We can call upon Double's new computed property to convert inches to meters
let oneInchInMeters = 1.inchToMeters

// Similarly, we'll convert three feet to meters
let threeFeetInMeters = 3.ftToMeters

// ------------------------------------------------------------------------------------------------
// Initializers
//
// Extensions can be used to add new convenience initializers to a class, but they cannot add
// new designated initializers.
//
// Let's see this in action:
struct Size
{
	var width = 0.0
	var height = 0.0
}
struct Point
{
	var x = 0.0
	var y = 0.0
}
struct Rect
{
	var origin = Point()
	var size = Size()
}

// Since we didn't provide any initializers, we can use Swift's default memberwise initializer for
// the Rect.
var memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

// Let's extend Rect to add a new convenience initializer. Note that we're still responsible for
// ensuring that the instance is fully initialized.
extension Rect
{
	init (center: Point, size: Size)
	{
		let originX = center.x - (size.width / 2)
		let originY = center.y - (size.height / 2)
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}

// Let's try out our new initializer:
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))

// Remember that if a class has an initializer, Swift will not provide the default memberwise
// initializer. However, since we added an initializer via an Extension, we still have access
// to Swift's memberwise initializer:
var anotherRect = Rect(origin: Point(x: 1.0, y: 1.0), size: Size(width: 3.0, height: 2.0))

// ------------------------------------------------------------------------------------------------
// Methods
//
// As you might expect, we can add methods to an existing type as well. Here's a clever little
// extention to perform a task (a closure) multiple times, equal to the value stored in the Int.
//
// Note that the integer value is stored in 'self'.
extension Int
{
	func repititions(task: () -> ())
	{
		for i in 0..<self
		{
			task()
		}
	}
}

// Let's call our new member using the shorthand syntax for trailing closures:
3.repititions { println("hello") }

// Instance methods can mutate the instance itself.
//
// Note the use of the 'mutating' keyword.
extension Int
{
	mutating func square()
	{
		self = self * self
	}
}

var someInt = 3
someInt.square() // someInt is now 9

// ------------------------------------------------------------------------------------------------
// Subscripts
//
// Let's add a subscript to Int:
extension Int
{
	subscript(digitIndex: Int) -> Int
	{
		var decimalBase = 1
		for _ in 0 ..< digitIndex
		{
			decimalBase *= 10
		}
		return self / decimalBase % 10
	}
}

// And we can call our subscript directly on an Int, including a literal Int type:
123456789[0]
123456789[1]
123456789[2]
123456789[3]
123456789[4]
123456789[5]
123456789[6]

// ------------------------------------------------------------------------------------------------
// Nested types
//
// We can also add nested types to an existing type:
extension Character
{
	enum Kind
	{
		case Vowel, Consonant, Other
	}
	var kind: Kind
	{
		switch String(self)
		{
			case "a", "e", "i", "o", "u":
				return .Vowel
			case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
			     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
				return .Consonant
			default:
				return .Other
		}
	}
}

// Let's test out our new extension with nested types:
Character("a").kind == .Vowel
Character("h").kind == .Consonant
Character("+").kind == .Other
