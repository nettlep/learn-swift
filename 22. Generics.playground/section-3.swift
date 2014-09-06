func swapTwoValues<T>(inout a: T, inout b: T)
{
	let tmp = a
	a = b
	b = tmp
}