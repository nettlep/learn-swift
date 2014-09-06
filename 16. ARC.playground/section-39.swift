class HTMLElement
{
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String =
	{
		if let text = self.text
		{
			return "<\(self.name)>\(text)</\(self.name)>"
		}
		else
		{
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil)
	{
		self.name = name
		self.text = text
	}
}