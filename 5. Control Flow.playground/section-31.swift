let someCharacter: Character = "e"
switch someCharacter
{
	case "a", "e", "i", "o", "u":
		"a vowel"
	
	case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "u", "z":
		"a consonant"

	// Necessary because switch statements must be exhaustive in order to capture all Characters
	default:
		"not a vowel or consonant"
}