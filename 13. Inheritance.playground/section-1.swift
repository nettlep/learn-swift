class Vehicle
{
	var numberOfWheels: Int
	var maxPassengers: Int
	
	func description() -> String
	{
		return "\(numberOfWheels) wheels; up to \(maxPassengers) passengers"
	}
	
	// Must initialize any properties that do not have a default value
	init()
	{
		numberOfWheels = 0
		maxPassengers = 1
	}
}