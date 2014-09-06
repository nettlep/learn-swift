func returnValue(f: () -> Int) -> Int
{
	// Simply return the value that the closure 'f' returns
	return f()
}