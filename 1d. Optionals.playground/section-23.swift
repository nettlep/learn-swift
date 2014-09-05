if let optionalIntValue:Int? = optionalConvertedNumber
{
	// 'optionalIntValue' is still an optional, but it's known to be safe. We can still check
	// it here, though, because it's still an optional. If it weren't optional, this if statement
	// wouldn't compile:
	if optionalIntValue != .None
	{
		// 'optionalIntValue' is optional, so we still use the force-unwrap here:
		"intValue is optional, but has the value \(optionalIntValue!)"
	}
}