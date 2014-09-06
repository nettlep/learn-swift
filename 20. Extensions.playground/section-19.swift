extension Int
{
	func repititions(task: () -> ())
	{
		for i in 0..<self
		{
			task()
		}
	}
}