class SurveyQuestion2
{
	// Default value of "No question"
	let text: String = "No question"
	
	var response: String?
	
	init(text: String)
	{
		// Initializing the constant, 'text', even though it has a default value, we can modify
		// that default value here
		self.text = text
	}
	
	init()
	{
		// We do nothing here and let the default value for 'text' define its value
	}
	
	func ask() -> String
	{
		return text
	}
}