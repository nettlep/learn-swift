result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "x":
				// Break completely out of the outer name loop
				break nameLoop
			
			default:
				result += String(character)
		}
	}
}
result