class SurveyQuestion
{
	var text: String
	
	// Response is optional, and is automatically initialized to nil
	var response: String?

	init(text: String)
	{
		// We only need to initialize 'text'
		self.text = text
	}
	
	func ask() -> String
	{
		return text
	}
}