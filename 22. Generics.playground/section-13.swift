func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int?
{
	for (index, value) in enumerate(array)
	{
		if value == valueToFind
		{
			return index
		}
	}
	return nil
}