enum ASCIIControlCharacter: Character
{
	case Tab = "\t"
	case LineFeed = "\n"
	case CarriageReturn = "\r"
	
	// Note that only Int type enumerations can auto-increment. Since this is a Character type,
	// the following line of code won't compile:
	//
	// case VerticalTab
}