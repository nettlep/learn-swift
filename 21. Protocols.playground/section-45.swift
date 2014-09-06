func wishHappyBirthday(celebrator: protocol<Named, Aged>) -> String
{
	return "Happy Birthday \(celebrator.name) - you're \(celebrator.age)!"
}