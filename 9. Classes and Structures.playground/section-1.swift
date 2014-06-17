// ------------------------------------------------------------------------------------------------
// Things to know:
//
// Classes and structures can both:
//
// * Define properties to store values
// * Define methods to provide functionality
// * Define subscripts to provide access to their values using subscript syntax
// * Define initializers to set up their initial state
// * Be extended to expand their functionality beyond a default implementation
// * Conform to protocols to provide standard functionality of a certain kind
//
// Only classes have:
//
// * Inheritance enables one class to inherit the characteristics of another.
// * Type casting enables you to check and interpret the type of a class instance at runtime.
// * Deinitializers enable an instance of a class to free up any resources it has assigned.
// * Reference counting allows more than one reference to a class instance.
// ------------------------------------------------------------------------------------------------

// First, let's create a basic structure with a couple of simple properties.
//
// Our structure must have all of its properties initialized, either with default values or through
// initialization (described later.) For now, we'll just ensure they're all initialized with
// default values.
struct Resolution
{
	var width = 1280
	var height = 1024
}

// Similarly, a basic class with a few properties, fully initialized. Notice that the first
// property is an instance of the Resolution structure.
//
// Also, note that the final member, the 'name' property, does not need to be initialized because
// optionals are initalized to nil by default.
class VideoMode
{
	var resolution = Resolution()
	var interlaced = false
	var frameRate = 0.0
	var name: String?
}

// Here are some instances of our structure and class:
var someResolution = Resolution()
var someVideoMode = VideoMode()

// ------------------------------------------------------------------------------------------------
// Accessing properties
//
// We can access members of the class or structure using the dot operator:
someResolution.width
someVideoMode.resolution.width

// In Objective-C, if an object contained a structure, the sub-properties (the properties of the
// structure inside the object) could not be modified directly. Instead the entire structure would
// have to be replaced completely. This is not the case for Swift.
someVideoMode.resolution.width = 2880
someVideoMode.resolution.height = 1800

// ------------------------------------------------------------------------------------------------
// Structures and Enumerations are Value Types
//
// This means that when passing an instance of a structure or enumeration to a function (or
// assigning an instance of a structure or enumeration to another value), the structure or
// enumeration is copied.
//
// Let's create two independent copies of a Resolution structure
let constantResolution = Resolution()
var variableResolution = constantResolution

// We can modify the variable resolution:
variableResolution.width = 320
variableResolution.height = 200

// We can see that the original (from where the variable copy originated) is unchanged:
constantResolution

// Note that since structures and enumerations are value types, we are unable to modify the
// contents of constant intances.
//
// The following will not compile:
//
// constantResolution.width = 320

// ------------------------------------------------------------------------------------------------
// Classes are Reference Types:
//
// This means that when passing an instance of an object to a function (or assigning an instance
// of an object to another value), the new value will hold a reference to the original object.
//
// Let's create an object and assign it's instance to another variable:
let constantVideoMode = VideoMode()
var variableVideoMode = constantVideoMode

// If we modify the variable..
variableVideoMode.frameRate = 240

// ...we can see that the other instance is also modified:
constantVideoMode.frameRate

// In addition to this, we can even modify the 'constantVideoMode' instance. This is the case
// because it is a reference type and modifing the contents do not modify the reference itself.
constantVideoMode.frameRate = 24

// We cannot, however, modify the instance variable.
//
// This line of code will not compile:
//
// constantVideoMode = VideoMode

// ------------------------------------------------------------------------------------------------
// Memberwise Initializers for Structure Types
//
// We can set the properties without the need to create a specialiized init routine. If a struct
// (not a class) does not have any initializers, then Swift will provide a "Memberwise Initializer"
// for us automatically.
//
// Here's what tha memberwise initializer looks like. It's pretty self-explanatory in that it is
// an initializer that includes one externally named parameter for each property in the structure.
let vga = Resolution(width: 640, height: 480)

// ------------------------------------------------------------------------------------------------
// Identity operators
//
// Since classes are reference types, we can check to see if they are 'identical' with the
// Identity (===) operator:
someVideoMode === variableVideoMode
constantVideoMode === variableVideoMode

// Identical-to is not the same as equal to:
//
// The following line will not compile as it uses the equality operator and VideoMode hasn't
// defined an equality operator:
//
// constantVideoMode == variableVideoMode
