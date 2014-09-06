class AutomaticCar: Car
{
	var gear = 1
	override var speed: Double
	{
		// Set the gear based on changes to speed
		didSet { gear = Int(speed / 10.0) + 1 }
	
		// Since we're overriding the property observer, we're not allowed to override the
		// getter/setter.
		//
		// The following lines will not compile:
		//
		// get { return super.speed }
		// set { super.speed = newValue }
	}
}