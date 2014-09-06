switch someValue
{
	case Int.min...100:
		"Small number"
	
	case 101...1000:
		break // We don't care about medium numbers
	
	case 1001...100_00:
		"Big number"
	
	default:
		break // We don't care about the rest, either
}