for thing in things
{
	switch thing
	{
		case 0 as Int:
			"zero as an Int"
		case 0 as Double:
			"zero as a Double"
		case let someInt as Int:
			"an integer value of \(someInt)"
		case let someDouble as Double where someDouble > 0:
			"a positive Double value of \(someDouble)"
		case is Double:
			"some other double that I don't want to print"
		case let someString as String:
			"a string value of \(someString)"
		case let (x, y) as (Double, Double):
			"a Tuple used to store an X/Y floating point coordinate: \(x), \(y)"
		case let movie as Movie:
			"A movie called '\(movie.name)'"
		default:
			"Something else"
	}
}