// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Arrays are ordered lists of elements
//
// * The types of values that can be stored in an array must always be made clear either through
//   explicit type annotation or through type inference and does not have to be a base class type.
//
// * Arrays are type-safe and always clear about what they contain.
//
// * Arrays are value types, but Swift is smart about only copying when necessary to improve
//   performance.
//
// * Immutable arrays are immutable in terms of the array itself and the contents of the array.
//   This means you can't add/remove an element nor can you modify an element of an immutable
//   array.
// ------------------------------------------------------------------------------------------------

// Create an array of Strings
var someArray = Array<String>()

// Shorter, more common way to define an array of Strings
var shorter: [String]

// This is an array literal. Since all members are of type String, this will create a String array.
//
// If all members are not the same type (or cannot be inferred to a homogenized type) then you
// would get a compiler error.
["Eggs", "Milk"]

// Let's create an array with some stuff in it. We'll use an explicit String type:
var commonPets: [String] = ["Cats", "Dogs"]

// We can also let Swift infer the type of the Array based on the type of the initializer members.
//
// The folowing is an array of Strings
var shoppingList = ["Eggs", "Milk"]

// ------------------------------------------------------------------------------------------------
// Accessing and modifying an Array
//
// We can get the number of elements
shoppingList.count

// We can check to see if it's empty
if !shoppingList.isEmpty { "it's not empty" }

// We can append to the end
shoppingList.append("Flour")
shoppingList.append("Baking Powder")
shoppingList.count

// We can append another array of same type
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
shoppingList.count

// We can get elements from the array by indexing them
shoppingList[0]
shoppingList[1]

// We can modify an existing item
shoppingList[0] = "Six Eggs"

// We can use a range operator to modify existing items. This operation modifies a range with
// a target range. If the target range has more or fewer elements in it, the size of the array
// will be adjusted.
//
// Here, we replace 3 items with only two, removing an item:
shoppingList[4...6] = ["Banannas", "Apples"]

// Or we can replace two items with three, inserting a new item:
shoppingList[4..<6] = ["Limes", "Mint leaves", "Sugar"]

// We can insert an item at a given index
shoppingList.insert("Maple Syrup", atIndex: 3)

// We can remove the last element. During this, we can preserve the value of what was removed
// into a stored value
let apples = shoppingList.removeLast()

// ------------------------------------------------------------------------------------------------
// Enumeration
//
// We can iterate over the the array using a for-in loop
for item in shoppingList
{
	item
}

// We can also use the the enumerate() method to return a tuple containing the index and value
// for each element:
for (index, value) in enumerate(shoppingList)
{
	index
	value
}

// ------------------------------------------------------------------------------------------------
// Creating and initializing an array
//
// Earlier, we saw how to declare an array of a given type. Here, we see how to declare an array
// type and then assign it to a stored value, which gets its type by inference:
var someInts = [Int]()

// Add the number '3' to the array
someInts.append(3)
someInts

// We can assign it to an empty array, but we don't modify the type, since someInts is already
// an Int[] type.
someInts = []

// We can initialize an array and and fill it with default values
var threeDoubles = [Double](count: 3, repeatedValue: 3.3)

// We can also use the Array initializer to fill it with default values. Note that we don't need to
// specify type since it is inferred:
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)

// If you store an array in a constant, it is considered "Immutable"
let immutableArray = ["a", "b"]

// In terms of immutability, it's important to consider that the array and its contents are treated
// separately. Therefore, you can change the contents of an immutable array, but you can't change
// the array itself.
//
// We can't change the contents of an immutable array:
//
// immutableArray[0] = "b"
//
// Nor can we change the size or add an element, you will get a compiler error:
//
// immutableArray += "c"

// ------------------------------------------------------------------------------------------------
// Arrays are Value Types
//
// Arrays are value types that only copy when necessary, which is only when the array itself
// changes (not the contents.)
//
// Here are three copies of an array:
var a = [1, 2, 3]
var b = a
var c = a

// However, if we change the contents of one array (mutating it), then it is copied and becomes its
// own unique entity:
a[0] = 42
b[0]
c[0]

// Now that we've changed a, it should have been copied to its own instance. Let's double-check
// that only b & c are the same:
a
b
c

// The same is true if we mutate the array in other ways (mofify the array's size)...
b.append(4)

// Now, we have three different arrays...
a
b
c

