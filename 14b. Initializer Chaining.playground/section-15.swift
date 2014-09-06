class ClassWithPI
{
	let estimatedPI: Double =
	{
		let constant1 = 22.0
		let constant2 = 7.0
		
		// Must return the type specified by the property
		return constant1 / constant2
	}()
}