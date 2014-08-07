// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Initializer Chaining refers to the way in which initialization takes place along the class
//   hierarchy.
//
// * Designated Initializers are those that are responsible for ensuring that the instance of a
//   class, structure or enumeration is properly initialized. These are the initializers you've
//   seen so far. Designated initializers are also resonsible for calling the superclass'
//   initializer.
//
// * Convenience Initializers are initializers that are provided for specialized initialization
//   and must call one of the designated initializers within a class in order to fulfill the
//   requirement of properly initializing a class.
// ------------------------------------------------------------------------------------------------

// Designated Initializers are the normal initializers ("init(...)") functions that you've seen
// so far. If the system creates an initializer for you, it will be a designated initializer.
//
// Convenience Initializers allow you to offer different code-paths through initialization, which
// call upon the designated initializers to do the heavy lifting. They use the keyword
// "convenience". They are actually different than designated initializers because Swift uses the
// difference (designated vs. convenience) to perform two-phase initialization, which we'll cover
// shortly.
//
// Here's what a simple case looks like with a designated and convenience initializer:
class Food
{
	var name: String

	// Designated initializer - required as the class does not have a default value for 'name'.
	// There can be more than one of these, but the fewer the better, usually, design-wise.
	init(name: String)
	{
		self.name = name
	}
	
	// Here, we'll use a convenience initializer to initialize 'name' to an unnamed Food
	convenience init()
	{
		// Must call the designated in same class
		self.init(name: "[unnamed]")
	}
}

// Here we make use of our two initializers
let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()

// ------------------------------------------------------------------------------------------------
// Two-Phase Initialization
//
// Two-phase initialization is a new concept enforced by Swift. Think of it like this:
//
// Phase 1: Subclasses MUST FIRST initialize any stored properties that are part of their subclass.
//          They must do this before they are allowed to cusomize a super's stored property.
//
//          Subclasses MUST THEN call the super's initializer, which will repeat this process
//          until the top-most superclass (the base class) is reached.
//
//          At this point we can assume that the class is fully initialized (but not necessarily
//          customized by the subclasses that may need to alter the initialization results.
//
// Phase 2:	In the base class' initializer, we can customize its properties before it returns to
//          the caller (a subclass.) That subclass is then allowed to write to any/all stored
//          properties defined by itself or the superclass chain. This continues until you get the
//          the bottom-most subclass.
//
// A note about convenience initializers:
//
// Convenience initializers must always call into a designated initializer from the current class.
// A designated initializer for a subclass must then into a super's iniitializer, which may also
// be a convenience initializer, because that convenience initializer will be required to
// eventually call a designated initializer before going higher up the chain.
//
// Let's derive a class from Food so we can see this in action:
class RecipeIngredient: Food
{
	var quantity: Int
	
	// This is a designated initializer (because it has no 'convenience' keyword)
	init(name: String, quantity: Int)
	{
		// We must initialize our new stored properties first (this is Phase 1)
		self.quantity = quantity
		
		// Next, we must call super's initializer (still, Phase 1)
		super.init(name: name)
		
		// Only after the super's initializer is called, can we customize any properties that
		// originated from someplace up the class hierarchy chain.
		self.name = "Ingredient: " + name
	}

	// Here, we'll create a convenience initializer that simply provides a default quantity
	// value of 1. Note that in order for this to compile, we are required to call a designated
	// initializer.
	convenience override init(name: String)
	{
		self.init(name: name, quantity: 1)
	}
}

// Now we can call our various initializers to see them in action:
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

// ------------------------------------------------------------------------------------------------
// Inheriting a full set of the super's initializers
//
// In the following class, we don't specify any initializer, but that's OK because we have default
// values for the stored property (purchased).
//
// Not providing any initializer at all allows us to gain a full set of the super's initializers.
class ShoppingListItem: RecipeIngredient
{
	var purchased = false
	var description: String
	{
		var output = "\(quantity) x \(name)"
		output += purchased ? " ✔" : " ✘"
		return output
	}
}

// Let's initialize our new ShoppingListItem using the super's initializer
let lotsOfCheese = ShoppingListItem(name: "cheese", quantity: 99)

// Here, we can create an array of ShippingListItems
var breakfastList = [
	ShoppingListItem(),
	ShoppingListItem(name: "Bacon"),
	ShoppingListItem(name: "Eggs", quantity: 6),
]

// ------------------------------------------------------------------------------------------------
// For individual properties, we can set their default value with a closure or function instead
// of just a literal value.
//
// In the example below, we use a closure to calculate the default value for 'estimatedPi'. Note
// the parenthesis at the end of the closure. Without them, we would be asking to set 'estimatedPI'
// to a closure type rather than to the result of the closure. Also, the parenthesis tell it to
// execute the closure immediately.
//
// Also note that these closures used for default values for properties are not allowed to access
// any of the other properties of the class because it's assumed that they have not yet been
// initialized.
class ClassWithPI
{
	let estimatedPI: Double =
	{
		let constant1 = 22.0
		let constant2 = 7.0
		
		// Must return the type specified by the property
		return constant1 / constant2
	}()
}

// Here's a more pracitcal example. Note that since the closure is required to return the type
// of the property it is initializing, it must create a temporary of the same type which is
// initialized and then returned.
struct CheckerBoard
{
	let boardColors: [Bool] =
	{
		var temporaryBoard = [Bool]()
		var isBlack = false
		for i in 1...10
		{
			for j in 1...10
			{
				temporaryBoard.append(isBlack)
				isBlack = !isBlack
			}
			
			isBlack = !isBlack
		}
		
		// Return the temporary in order to set 'boardColors'
		return temporaryBoard
	}()
	
	func squareIsBlackAtRow(row: Int, column: Int) -> Bool
	{
		return boardColors[(row * 10) + column]
	}
}

// We can now check our work
var board = CheckerBoard()
board.squareIsBlackAtRow(1, column: 1) // Should be false
board.squareIsBlackAtRow(1, column: 2) // Should be true
