class StepCounterShorterWithModify
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { totalSteps = totalSteps & 0xff }
	}
}
var stepper = StepCounterShorterWithModify()
stepper.totalSteps = 345
stepper.totalSteps // This reports totalSteps is now set to 89