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