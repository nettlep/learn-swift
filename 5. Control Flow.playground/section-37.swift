let somePoint = (1,1)
switch somePoint
{
	case (0,0):
		"origin"
	
	// Match only against y=0
	case (_, 0):
		"On the X axis"
	
	// Match only against x=0
	case (0, _):
		"On the y axis"
	
	// Match x and y from -2 to +2 (inclusive)
	case (-2...2, -2...2):
		"On or inside the 2x2 box"
	
	// Everything else
	default:
		"Outisde the 2x2 box"
}