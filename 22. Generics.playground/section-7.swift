struct Stack<T>
{
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
}