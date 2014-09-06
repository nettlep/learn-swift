let integerToDescribe = 5
var integerDescription = "\(integerToDescribe) is"
switch integerToDescribe
{
	case 2, 3, 5, 7, 11, 13, 17, 19:
		integerDescription += " a prime number, and also"
		fallthrough
	
	default:
		integerDescription += " an integer."
}