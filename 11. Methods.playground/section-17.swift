enum TriStateSwitch
{
	case Off, Low, High
	mutating func next()
	{
		switch self
		{
		case Off:
			self = Low
		case Low:
			self = High
		case High:
			self = Off
		}
	}
}