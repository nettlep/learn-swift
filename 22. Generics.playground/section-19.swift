struct StackContainer<T> : Container
{
	// Here we find our original stack implementation, unmodified
	
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
	
	// Below, we conform to the protocol
	
	mutating func append(item: T)
	{
		self.push(item)
	}
	var count: Int
	{
		return items.count
	}
	subscript(i: Int) -> T
	{
		return items[i]
	}
}