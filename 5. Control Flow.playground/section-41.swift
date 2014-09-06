switch anotherPoint
{
	case (let x, 0):
		"On the x axis with an x value of \(x)"
	
	case (0, let y):
		"On the y axis with an y value of \(y)"
	
	case (var x, let y):
		++x // We can modify the variable 'x', but not the constant 'y'
		"Somewhere else on \(x), \(y)"
}