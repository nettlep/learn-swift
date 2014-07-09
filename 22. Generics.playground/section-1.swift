// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Generics allow flexible, reusable functions and types that can work with any type, subject
//   to restrictions that you define.
//
// * Swift's Array and Dictionary are both Generics.
//
// * Generics can be applied to Functions, Structures, Classes and Enumerations.
// ------------------------------------------------------------------------------------------------

// The problem that Generics solve
//
// Consider the following function which can swap two Ints.
func swapTwoInts(inout a: Int, inout b: Int)
{
	let tmp = a
	a = b
	b = tmp
}

// What if we wanted to swap Strings? Or any other type? We would need to write a lot of different
// swap functions. Instead, let's use Generics. Consider the following generic function:
func swapTwoValues<T>(inout a: T, inout b: T)
{
	let tmp = a
	a = b
	b = tmp
}

// The 'swapTwoValues()' function is a generic function in a sense that some or all of the types
// that it works on are generic (i.e., specific only to the calls placed on that function.)
//
// Study the first line of the function and notice the use of <T> and the type for 'a' and 'b' as
// type T. In this case, T is just a placeholder for a type and by studying this function, we can
// see that both 'a' and 'b' are the same type.
//
// If we call this function with two Integers, it will treat the function as one declared to accept
// two Ints, but if we pass in two Strings, it will work on Strings.
//
// If we study the body of the function, we'll see that it is coded in such a way as to work with
// any type passed in: The 'tmp' parameter's type is inferred by the value 'a' and 'a' and 'b' must
// be assignable. If any of this criteria are not met, a compilation error will appear for the
// function call the tries to call swapTwoValues() with a type that doesn't meet this criteria.
//
// Although we're using T as the name for our type placeholder, we can use any name we wish, though
// T is a common placeholder for single type lists. If we were to create a new implementation of
// the Dictionary class, we would want to use two type parameters and name them effectively, such
// as <KeyType, ValueType>.
//
// A type placholder can also be used to define the return type.
//
// Let's call it a few times to see it in action:
var aInt = 3
var bInt = 4
swapTwoValues(&aInt, &bInt)
aInt
bInt

var aDouble = 3.3
var bDouble = 4.4
swapTwoValues(&aDouble, &bDouble)
aDouble
bDouble

var aString = "three"
var bString = "four"
swapTwoValues(&aString, &bString)
aString
bString

// ------------------------------------------------------------------------------------------------
// Generic Types
//
// So far we've seen how to apply Generics to a function, let's see how they can be applied to
// a struct. We'll define a standard 'stack' implementation which works like an array that can
// "push" an element to the end of the array, or "pop" an element off of the end of the array.
//
// As you can see, the type placeholder, once defined for a struct, can be used anywhere in that
// struct to represent the given type. In the code below, the the type placeholder is used as the
// type for a property, the input parameter for a method and the return value for a method.
struct Stack<T>
{
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
}

// Let's use our new Stack:
var stackOfStrings = Stack<String>()

stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

stackOfStrings.pop()
stackOfStrings.pop()
stackOfStrings.pop()
stackOfStrings.pop()

// ------------------------------------------------------------------------------------------------
// Type constraints
//
// So far, our type parameters are completely Generic - they can represent any given type.
// Sometimes we may want to apply constraints to those types. For example, the Swift Dictionary
// type uses generics and places a constraint on the key's type that it must be hashable (i.e., it
// must conform to the Hashable protocol, defined in the Swift standard library.)
//
// Constraints are defined with the following syntax:
func doSomethingWithKeyValue<KeyType: Hashable, ValueType>(someKey: KeyType, someValue: ValueType)
{
	// Our keyType is known to be a Hashable, so we can use the hashValue defined by that protocol
	// shown here:
	someKey.hashValue
	
	// 'someValue' is an unknown type to us, we'll just drop it here in case it's ever used so we
	// can see the value
	someValue
}

// Let's see type constraints in action. We'll create a function that finds a given value within
// an array and returns an optional index into the array where the first element was found.
//
// Take notice the constraint "Equatable" on the type T, which is key to making this function
// compile. Without it, we would get an error on the conditional statement used to compare each
// element from the array with the value being searched for. By including the Equatable, we tell
// the generic function that it is guaranteed to receive only values that meet that specific
// criteria.
func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int?
{
	for (index, value) in enumerate(array)
	{
		if value == valueToFind
		{
			return index
		}
	}
	return nil
}

// Let's try a few different inputs
let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")

// ------------------------------------------------------------------------------------------------
// Associated types
//
// Protocols use a different method of defining generic types, called Associated Types, which use
// type inference combined with Type Aliases.
//
// Let's jump right into some code:
protocol Container
{
	typealias ItemType
	mutating func append(item: ItemType)
	var count: Int { get }
	subscript(i: Int) -> ItemType { get }
}

// In the example above, we declare a Type Alias called ItemType, but because we're declaring
// a protocol, we're only declaring the requirement for the conforming target to provide the
// actual type alias.
//
// With Generics, the type of ItemType can actually be inferred, such that it provides the correct
// types for the append() and the subscript implementations.
//
// Let's see this in action as we turn our Stack into a container:

struct StackContainer<T> : Container
{
	// Here we find our original stack implementation, unmodified
	
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
	
	// Below, we conform to the protocol
	
	mutating func append(item: T)
	{
		self.push(item)
	}
	var count: Int
	{
		return items.count
	}
	subscript(i: Int) -> T
	{
		return items[i]
	}
}

// The new StackContainer is now ready to go. You may notice that it does not include the
// typealias that was required as part of the Container protocol. This is because the all of the
// places where an ItemType would be used are using T. This allows Swift to perform a backwards
// inferrence that ItemType must be a type T, and it allows this requirement to be met.
//
// Let's verify our work:
var stringStack = StackContainer<String>()
stringStack.push("Albert")
stringStack.push("Andrew")
stringStack.push("Betty")
stringStack.push("Jacob")
stringStack.pop()
stringStack.count

var doubleStack = StackContainer<Double>()
doubleStack.push(3.14159)
doubleStack.push(42.0)
doubleStack.push(1_000_000)
doubleStack.pop()
doubleStack.count

// We can also extend an existing types to conform to our new generic protocol. As it turns out
// Swift's built-in Array class already supports the requirements of our Container.
//
// Also, since the protocol's type inferrence method of implementing Generics, we can extend
// String without the need to modify String other than to extend it to conform to the protocol:
extension Array: Container {}

// ------------------------------------------------------------------------------------------------
// Where Clauses
//
// We can further extend our constraints on a type by including where clauses as part of a type
// parameter list. Where clauses provide a means for more constraints on associated types and/or
// one or more equality relationships between types and associated types.
//
// Let's take a look at a where clause in action. We'll define a function that works on two
// different containers that that must contain the same type of item.
func allItemsMatch
	<C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
	(someContainer: C1, anotherContainer: C2) -> Bool
{
	// Check that both containers contain the same number of items
	if someContainer.count != anotherContainer.count
	{
		return false
	}
	
	// Check each pair of items to see if they are equivalent
	for i in 0..<someContainer.count
	{
		if someContainer[i] != anotherContainer[i]
		{
			return false
		}
	}
	
	// All items match, so return true
	return true
}

// The function's type parameter list places the following restrictions on the types allowed:
//
// * C1 must conform to the Container protocol (C1: Container)
// * C2 must also conform to the Container protocol (C1: Container)
// * The ItemType for C1 must be the same as the ItemType for C2 (C1.ItemType == C2.ItemType)
// * The ItemType for C1 must conform to the Equatable protocol (C1.ItemType: Equatable)
//
// Note that we only need to specify that C1.ItemType conforms to Equatable because the code
// only calls the != operator (part of the Equatable protocol) on someContainer, which is the
// type C1.
//
// Let's test this out by passing the same value for each parameter which should definitely
// return true:
allItemsMatch(doubleStack, doubleStack)

// We can compare stringStack against an array of type String[] because we've extended Swift's
// Array type to conform to our Container protocol:
allItemsMatch(stringStack, ["Alpha", "Beta", "Theta"])

// Finally, if we attempt to call allItemsMatch with a stringStack and a doubleStack, we would get
// a compiler error because they do not store the same ItemType as defined in the function's
// where clause.
//
// The following line of code does not compile:
//
// allItemsMatch(stringStack, doubleStack)
