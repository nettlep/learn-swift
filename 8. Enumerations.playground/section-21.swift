enum StatusCode: Int
{
	case Error = -1
	case Success = 9
	case OtherResult = 1
	case YetAnotherResult // Unspecified values are auto-incremented from the previous value
}