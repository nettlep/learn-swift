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