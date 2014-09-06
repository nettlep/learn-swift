extension Dice: PrettyTextRepresentable
{
	func asPrettyText() -> String
	{
		return "The pretty version of " + asText()
	}
}