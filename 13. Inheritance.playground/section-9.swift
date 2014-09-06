class Car: Vehicle
{
	// Adding a new property
	var speed: Double = 0.0
	
	// New initialization, starting with super.init()
	override init()
	{
		super.init()
		maxPassengers = 5
		numberOfWheels = 4
	}
	
	// Using the override keyword to specify that we're overriding a function up the inheritance
	// chain. It is a compilation error to leave out 'override' if a method exists up the chain.
	override func description() -> String
	{
		// We start with the default implementation of description then tack our stuff onto it
		return super.description() + "; " + "traveling at \(speed) mph"
	}
}