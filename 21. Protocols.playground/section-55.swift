@objc protocol CounterDataSource
{
	optional func incrementForCount(count: Int) -> Int
	optional var fixedIncrement: Int { get }
}