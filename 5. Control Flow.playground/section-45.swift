let someValue = 9000
switch someValue
{
	case let x where (x & 1) == 1:
		if someValue < 100
		{
			"Odd number less than 100"
			break
		}
		"Odd number greater or equal to 100"
		
	case let x where (x & 1) == 0:
		if someValue < 100
		{
			"Even number less than 100"
			break
		}
		"Even number greater or equal to 100"
	
	default:
		"Unknown value"
}