class StepCounter
{
	var totalSteps: Int = 0
	{
		willSet(newTotalSteps)
		{
			"About to step to \(newTotalSteps)"
		}
		didSet(oldTotalSteps)
		{
			"Just stepped from \(oldTotalSteps)"
		}
	}
}