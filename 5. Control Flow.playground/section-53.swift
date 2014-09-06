result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "a":
				// Continue directly to the character loop, bypassing this character in this name
				continue characterLoop
			
			default:
				result += String(character)
		}
	}
}
result