func allItemsMatch
	<C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
	(someContainer: C1, anotherContainer: C2) -> Bool
{
	// Check that both containers contain the same number of items
	if someContainer.count != anotherContainer.count
	{
		return false
	}
	
	// Check each pair of items to see if they are equivalent
	for i in 0..<someContainer.count
	{
		if someContainer[i] != anotherContainer[i]
		{
			return false
		}
	}
	
	// All items match, so return true
	return true
}