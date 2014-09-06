class StepCounterShorter
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { "Just stepped from \(oldValue)" }
	}
}