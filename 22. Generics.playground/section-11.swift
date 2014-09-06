func doSomethingWithKeyValue<KeyType: Hashable, ValueType>(someKey: KeyType, someValue: ValueType)
{
	// Our keyType is known to be a Hashable, so we can use the hashValue defined by that protocol
	// shown here:
	someKey.hashValue
	
	// 'someValue' is an unknown type to us, we'll just drop it here in case it's ever used so we
	// can see the value
	someValue
}