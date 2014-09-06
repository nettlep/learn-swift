final class AnotherAutomaticCar: Car
{
	// This variable cannot be overridden
	final var gear = 1
	
	// We can even prevent overridden functions from being further refined
	final override var speed: Double
	{
		didSet { gear = Int(speed / 10.0) + 1 }
	}
}