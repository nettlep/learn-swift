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
//   performance. This has important implications for immutability.
//
// * Immutable arrays (constant arrays) can allow their contents to change, which differs from the
//   other type of Collection, Dictionaries.
// ------------------------------------------------------------------------------------------------

// Create an array of Strings
var someArray = Array<String>()

// Shorter, more common way to define an array of Strings
var shorter: String[]

// This is an array literal. Since all members are of type String, this will create a String array.
//
// If all members are not the same type (or cannot be inferred to a homogenized type) then you
// would get a compiler error.
["Eggs", "Milk"]

// Let's create an array with some stuff in it. We'll use an explicit String type:
var commonPets: String[] = ["Cats", "Dogs"]

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
shoppingList.count

// We can append to the end with the compound assigmnent operator
shoppingList += "Baking Powder"
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
shoppingList[4..6] = ["Limes", "Mint leaves", "Sugar"]

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
var someInts = Int[]()

// Add the number '3' to the array
someInts.append(3)
someInts

// We can assign it to an empty array, but we don't modify the type, since someInts is already
// an Int[] type.
someInts = []

// We can initialize an array and and fill it with default values
var threeDoubles = Double[](count: 3, repeatedValue: 3.3)

// We can also use the Array initializer to fill it with default values. Note that we don't need to
// specify type since it is inferred:
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)

// If you store an array in a constant, it is considered "Immutable"
let immutableArray = ["a", "b"]

// In terms of immutability, it's important to consider that the array and its contents are treated
// separately. Therefore, you can change the contents of an immutable array, but you can't change
// the array itself.
//
// We change the contents of an immutable array:
immutableArray[0] = "b"

// But if you try to change the size or add an element, you will get a compiler error:
//
// immutableArray += "c"

// ------------------------------------------------------------------------------------------------
// Arrays are Value Types
//
// Arrays are value types that only copy when necessary, which is only when the array itself
// changes (not the contents.)
//
// Here are three copies of the same array:
var a = [1, 2, 3]
var b = a
var c = a

// They are all the same...
a[0]
b[0]
c[0]

// Change one value within the array and they all change:
a[0] = 42
b[0]
c[0]

// But if we mofify the array's size, then the array being mutated is copied and becomes its own
// unique entity.
a.append(4)
a[0] = 1

// Now, a is different from b and c
a
b
c

// Since 'b' and 'c' effectivly share the same contents, you can force one to become unique without
// modifying the array's size using the Array's unshare() method.
//
// The unshare() method is performant because it doesn't actually copy the array contents until
// it has to (if ever.)
b.unshare()

// They still appear to be the same...
b
c

// ...but b is actually a unique copy. Let's change an element in b:
b[0] = 99

// And we can see that our change only affects b:
b
c

// We can further verify this by comparing if they are the same instance:
if b === c
{
	"b & c still share same array elements"
}
else
{
	"b & c now refer to two independent arrays"
}

// This works with sub-arrays, too:
if b[0...1] === b[0...1]
{
	"these guys are shared"
}
else
{
	"these guys are NOT shared"
}

// Forcing a copy of an array
//
// Use the copy() method to force a shallow copy.
//
// Unlike the unshare method, the copy will happen immediately when calling copy().
var d = a.copy()
a[0] = 101
d[0]
