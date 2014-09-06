if let intValue = optionalConvertedNumber
{
	// No need to use the "!" suffix as intValue is not optional
	intValue
	
	// In fact, since 'intValue' is an Int (not an Int?) we can't use the force-unwrap. This line
	// of code won't compile:
	// intValue!
}
else
{
	// Note that 'intValue' doesn't exist in this "else" scope
	"No value"
}