var result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "a":
				// Break out of the theSwitch and characterLoop
				break characterLoop
			
			default:
				result += String(character)
		}
	}
}
result