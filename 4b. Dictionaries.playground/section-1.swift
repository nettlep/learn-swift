// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Dictionaries store multiple values of the same type, each associated with a key which acts as
//   an identifier for that value within the dictionary.
//
// * Dictionaries are type-safe and always clear about what they contain.
//
// * The types of values that can be stored in a dictionary must always be made clear either
//   through explicit type annotation or through type inference.
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// Creating a dictionary
//
// This is a Dictionary literal. They contain a comma-separated list of key:value pairs:
["TYO": "Tokyo", "DUB": "Dublin"]

// Let's use that literal to define and initialize a Dictionary.
//
// In this case, we use type annotation to explicitly declare a Dictionary containing String keys
// and String values. This uses the syntactic sugar "[ KeyType: ValueType ]" to declare the
// dictionary.
var airports: [String : String] = ["TYO": "Tokyo", "DUB": "Dublin", "APL": "Apple Intl"]

// The declaration for airports above could also have been declared in this way:
var players: Dictionary<String, String> = ["Who" : "First", "What" : "Second"]

// In the case below, the literal contains only Strings for all keys and only Strings for all
// values, so type inference works in our favor allowing us to avoid the type annotation:
let inferredDictionary = ["TYO": "Tokyo", "DUB": "Dublin"]

// ------------------------------------------------------------------------------------------------
// Accessing and modifying a Dictionary
//
// Let's get a value from the dictionary for the TYO airport:
airports["TYO"]

// What happens if we try to get a value that doesn't exist?
//
// Since this can happen, the Dictionary always retuns an optional, so in the next line of code,
// notFound will be nil. It will also be of type String?
var notFound = airports["FOO"]

// We can get the number of elements in the dictionary:
airports.count

// We can add an element by accessing a key that doesn't exist:
airports["LHR"] = "London"

// Here's another way to set/update a value. This lets us get the previous value before we set
// the new one. The returned value is optional, in case the new value doesn't replace an existing
// one:
var previousValue = airports.updateValue("Dublin International", forKey: "DUB")

// We can remove an entry by setting the value for a key to nil:
airports["APL"] = nil

// Here's another way to remove a value. The returned value is set to the value that was removed.
// Again, this is optional in case there was no value to remove. In this case, the APL airport
// was already removed, so the return value will be a nil optional:
var removedValue = airports.removeValueForKey("APL")

// ------------------------------------------------------------------------------------------------
// Iterating over a Dictionary
//
// We can iterating over key/value pairs with a for-in loop, which uses a Tuple to hold the
// key/value pair for each entry in the Dictionary:
for (airportCode, airportName) in airports
{
	airportCode
	airportName
}

// We can iterate over just the keys
for airportCode in airports.keys
{
	airportCode
}

// We can iterate over jsut the values
for airportName in airports.values
{
	airportName
}

// We can create an array from the keys or values
//
// Note that when doing this, the use of Array() is needed to convert the keys or values into
// an array.
var airportCodes = Array(airports.keys)
var airportNames = Array(airports.values)

// ------------------------------------------------------------------------------------------------
// Creating an empty Dictionary
//
// Here, we create an empty Dictionary of Int keys and String values:
var namesOfIntegers = Dictionary<Int, String>()

// Let's set one of the values
namesOfIntegers[16] = "Sixteen"

// We can empty a dictionary using an empty dictionary literal:
namesOfIntegers = [:]

// An immutable dictionary is a constant.
let immutableDict = ["a": "one", "b": "two"]

// Similar to arrays, we cannot modify the contents of an immutable dictionary. The following lines
// will not compile:
//
// immutableDict["a"] = "b" // You cannot modify an element
// immutableDict["c"] = "three" // You cannot add a new entry or change the size

// Dictionaries are value types, which means they are copied on assignment.
//
// Let's create a Dictionary and copy it:
var ages = ["Peter": 23, "Wei": 35, "Anish": 65, "Katya": 19]
var copiedAges = ages

// Next, we'll modify the copy:
copiedAges["Peter"] = 24

// And we can see that the original is not changed:
ages["Peter"]

