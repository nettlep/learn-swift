class Bicycle: Vehicle
{
	// We'll make this a 2-wheeled vehicle
	override init()
	{
		super.init()
		numberOfWheels = 2
	}
}