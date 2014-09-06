if optionalConvertedNumber != .None
{
	// It's now safe to force-unwrap because we KNOW it has a value
	let anotherUnwrappedInt = optionalConvertedNumber!
}
else
{
	// The optional holds "no value"
	"Nothing to see here, go away"
}