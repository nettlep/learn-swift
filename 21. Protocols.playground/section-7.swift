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