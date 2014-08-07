// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Protocols define a required set of functionality (including methods and properties) for a
//   class, structure or enumeration.
//
// * Protocols are "adopted" by a class, structure or enumeration to provide the implementation.
//   This is called "conforming" to a protocol.
//
// * As you should already be aware, protocols are often used for delegation.
//
// * Protcol Syntax looks like this:
//
//		protocol SomeProtocol
//		{
//			// protocol definition goes here
//		}
//
// * Protocol adoption looks like this:
//
//		struct SomeStructure: FirstProtocol, AnotherProtocol
//		{
//			// structure definition goes here
//		}
//
//		class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol
//		{
//			// class definition goes here
//		}
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// Property requirements
//
// * A protocol can require the conforming type to provide an instance of a property or type
//   property.
//
// * The protocol can also specify if the property must be gettable or gettable and
//   settable. If a protocol only requires a gettable property, the conforming class can use
//   a stored property or a computed property. Also, the conforming class is allowed to add
//   a setter if it needs.
//
// * Property requirements are always declared as variable types with the 'var' introducer.
//
// Let's take a look at a simple protocol. As you'll see, we only need to define the properties
// in terms of 'get' and 'set' and do not provide the actual functionality.
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

// Let's create a more practical protocol that we can actually conform to:
protocol FullyNamed
{
	var fullName: String { get }
}

// A structure that conforms to FullyNamed. We won't bother creating an explicit getter or setter
// for the 'fullName' property because Swift's defaults will suffice.
struct Person: FullyNamed
{
	var fullName: String
}

let john = Person(fullName: "John Smith")

// Let's try a more complex class
class Starship: FullyNamed
{
	var prefix: String?
	var name: String
	init(name: String, prefix: String? = nil)
	{
		self.name = name
		self.prefix = prefix
	}
	
	var fullName: String
	{
		return (prefix != .None ? prefix! + " " : "") + name
	}
}

// In the class above, we use a 'name' and an optional 'prefix' to represent the full name, then
// provide a computed value to fulfill our 'fullName' requirement.
//
// Here it is in action:
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName

// ------------------------------------------------------------------------------------------------
// Method Requirements
//
// Similar to property requirements, the protocol only defines the method type, not the
// implementation.
//
// Variadic parameters are allowed, but default values are not.
//
// Method requirements can be mutating - simply use the 'mutating' keyword before the function
// definition. Note that when conforming to the protocol, only classes are required to use the
// 'mutating' keyword when conforming to the protocol, following the normal procedure.
//
// As with property requirements, type methods are always prefixed with the 'class' keyword.
//
// Here's a simple example that defines the requirements for a 'random' function which takes
// no parameters and returns a Double:
protocol RandomNumberGenerator
{
	func random() -> Double
}

// Let's adopt this protocol:
class LinearCongruentialGenerator: RandomNumberGenerator
{
	var lastRandom = 42.0
	var m = 139956.0
	var a = 3877.0
	var c = 29573.0
	func random() -> Double
	{
		lastRandom = ((lastRandom * a + c) % m)
		return lastRandom / m
	}
}
let generator = LinearCongruentialGenerator()
generator.random()
generator.random()
generator.random()

// ------------------------------------------------------------------------------------------------
// Protocols as Types
//
// Protocols are types, which means they can be used where many other types are allowed,
// including:
//
// * As a parameter to a function, method or initializer
// * As the type of a constant, variable or property
// * As the type of items in an Array, Dictionary or other container
//
// Here's a protocol used as a type. We'll create a Dice class that stores a RandomNumberGenerator
// as a constant so that it can be used to customize the randomization of the dice roll:
class Dice
{
	let sides: Int
	let generator: RandomNumberGenerator
	init(sides: Int, generator: RandomNumberGenerator)
	{
		self.sides = sides
		self.generator = generator
	}
	
	func roll() -> Int
	{
		return Int(generator.random() * Double(sides)) + 1
	}
}

// Just for fun, let's roll a few:
let d6 = Dice(sides: 6, generator: generator)
d6.roll()
d6.roll()
d6.roll()
d6.roll()
d6.roll()
d6.roll()

// ------------------------------------------------------------------------------------------------
// Adding Protocol Conformance with an Extension
//
// Existing classes, structures and enumerations can be extended to conform to a given protocol.
//
// Let's start with a simple protocol we'll use for expirimentation:
protocol TextRepresentable
{
	func asText() -> String
}

// We'll extend our Dice class:
extension Dice: TextRepresentable
{
	func asText() -> String
	{
		return "A \(sides)-sided dice"
	}
}

// Existing instances (such as 'd6' will automatically adopt and conform to the new protocol, even
// though it was declared prior to the extension.
d6.asText()

// ------------------------------------------------------------------------------------------------
// Declaring Protocol Adoption with an Extension
//
// Some types may already adopt a protocol, but do not state so in their definition. Types do not
// automatically adopt to protocols whose requirements they satisfy - protocol adoption must
// always be stated explicitly.
//
// This can be resolved with by using an empty extension.
//
// To showcase this, let's create a structure that conforms to the TextRepresentable protocol, but
// doesn't include this as part of the definition:
struct Hamster
{
	var name: String
	func asText() -> String
	{
		return "A hamster named \(name)"
	}
}

// Let's verify our work:
let tedTheHamster = Hamster(name: "Ted")
tedTheHamster.asText()

// We can add TextRepresentable conformance to Hamster by using an empty extension.
//
// This works because the requirements are already met, so we don't need to include any additional
// functionality within the extension definition.
extension Hamster: TextRepresentable
{
	
}

// ------------------------------------------------------------------------------------------------
// Collections of Protocol Types
//
// Hamsters and Dice don't have much in common, but in our sample code above, they both conform
// to the TextRepresentable protocol. Because of this, we can create an array of things that are
// TextRepresentable which includes each:
let textRepresentableThigns: [TextRepresentable] = [d6, tedTheHamster]

// We can now loop through each and produce its text representation:
for thing in textRepresentableThigns
{
	thing.asText()
}

// ------------------------------------------------------------------------------------------------
// Protocol Inheritance
//
// Protocols can inherit from other protocols in order to add further requirements. The syntax
// for this is similar to a class ineriting from its superclass.
//
// Let's create a new text representable type, inherited from TextRepresentable:
protocol PrettyTextRepresentable: TextRepresentable
{
	func asPrettyText() -> String
}

// Let's make our Dice a little prettier.
//
// Note that the Dice already knows that it conforms to the TextRepresentable, which means we can
// call asText() inside our asPrettyText() method.
extension Dice: PrettyTextRepresentable
{
	func asPrettyText() -> String
	{
		return "The pretty version of " + asText()
	}
}

// We can test our work:
d6.asPrettyText()

// ------------------------------------------------------------------------------------------------
// Protocol Composition
//
// Protocols can be combined such that a type conforms to each of them. For example, a person can
// be an aged person as well as a named person.
//
// Protocol Composition is a syntactic method of declaring that an instance conforms to a set
// of protocols. It takes the form "protocol<SomeProtocol, AnotherProtocol>". There can be as
// many protocols between the angle brackets as you need.
//
// Let's start by creating a couple of protocols for expirimentation:
protocol Named
{
	var name: String { get }
}
protocol Aged
{
	var age: Int { get }
}

// Here, we declare an Individual that conforms to both Name and Age protocols:
struct Individual: Named, Aged
{
	var name: String
	var age: Int
}

// Here, we can see the protocol composition at work as the parameter into the wishHappyBirthday()
// function:
func wishHappyBirthday(celebrator: protocol<Named, Aged>) -> String
{
	return "Happy Birthday \(celebrator.name) - you're \(celebrator.age)!"
}

// If we call the member, we can see the celebratory wish for this individual:
wishHappyBirthday(Individual(name: "Bill", age: 31))

// ------------------------------------------------------------------------------------------------
// Checking for Protocol Conformance
//
// We can use 'is' and 'as' for testing for protocol conformance, just as we've seen in the
// section on Type Casting.
//
// In order for this to work with protocols, they must be marked with an "@objc" attribute. See
// further down in this playground for a special note about the @objc attribute.
//
// Let's create a new protocol with the proper prefix so that we can investigate:
@objc protocol HasArea
{
	var area: Double { get }
}

class Circle: HasArea
{
	let pi = 3.14159
	var radius: Double
	var area: Double { return pi * radius * radius }
	init(radius: Double) { self.radius = radius }
}
class Country: HasArea
{
	var area: Double
	init(area: Double) { self.area = area }
}
class Animal
{
	var legs: Int
	init(legs: Int) { self.legs = legs }
}

// We can store our objects into an array of type AnyObject[]
let objects: [AnyObject] =
[
	Circle(radius: 3.0),
	Country(area: 4356947.0),
	Animal(legs: 4)
]

// Then we can test each for conformance to HasArea:
objects[0] is HasArea
objects[1] is HasArea
objects[2] is HasArea

// ------------------------------------------------------------------------------------------------
// Optional Protocol Requirements
//
// Sometimes it's convenient to declare protocols that have one or more requirements that are
// optional. This is done by prefixing those requirements with the 'optional' keyword.
//
// The term "optional protocol" refers to protocols that are optional in a very similar since to
// optionals we've seen in the past. However, rather than stored values that can be nil, they
// can still use optional chaining and optional binding for determining if an optional requirement
// has been satisfied and if so, using that requirement.
//
// As with Protocol Conformance, a protocol that uses optional requirements must also be prefixed
// with the '@objc' attribute.
//
// A special note about @objc attribute:
//
// * In order to check if an instance of a class conforms to a given protocol, that protocol must
//   be declared with the @objc attribute.
//
// * This is also the case with optional requirements in protocols. In order to use the optional
//   declaration modifier, the protocol must be declared with the @objc attribute.
//
// * Additionally, any class, structure or enumeration that owns an instance that conforms to a
//   protocol declared with the @objc attribute must also be declared with the @objc attribute.
//
// Here's another simple protocol that uses optional requrements:
@objc protocol CounterDataSource
{
	optional func incrementForCount(count: Int) -> Int
	optional var fixedIncrement: Int { get }
}

// In the class below, we'll see that checking to see if an instance conforms to a specific
// requirement is similar to checking for (and accessing) optionals. We'll use optional chaining
// for these optional reqirements:
@objc class Counter
{
	var count = 0
	var dataSource: CounterDataSource?
	func increment()
	{
		// Does the dataSource conform to the incrementForCount method?
		if let amount = dataSource?.incrementForCount?(count)
		{
			count += amount
		}
		// If not, does it conform to the fixedIncrement variable requirement?
		else if let amount = dataSource?.fixedIncrement?
		{
			count += amount
		}
	}
}
