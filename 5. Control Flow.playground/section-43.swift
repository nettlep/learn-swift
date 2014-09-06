let yetAnotherPoint = (1, -1)
switch yetAnotherPoint
{
	case let (x, y) where x == y:
		"On the line of x == y"
	
	case let (x, y) where x == -y:
		"On the line of x == -y"
	
	case let (x, y):
		"Just some arbitrary point"
}