var anotherPoint = (2, 8)
switch anotherPoint
{
	// Bind 'x' to the first value (matching any x) of the tuple and match on y=0
	case (let x, 0):
		"On the x axis with an x value of \(x)"
	
	// Bind 'y' to the second value (matching any y) of the tuple and match against x=0
	case (0, let y):
		"On the y axis with an y value of \(y)"
	
	// Bind both values of the tuple, matching any x or y. Note the shorthand of the 'let'
	// outside of the parenthesis. This works with 'var' as well.
	//
	// Also notice that since this matches any x or y, we fulfill the requirement for an exhaustive
	// switch.
	case let (x, y):
		"Somewhere else on \(x), \(y)"
}