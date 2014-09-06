extension Character
{
	enum Kind
	{
		case Vowel, Consonant, Other
	}
	var kind: Kind
	{
		switch String(self)
		{
			case "a", "e", "i", "o", "u":
				return .Vowel
			case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
			     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
				return .Consonant
			default:
				return .Other
		}
	}
}