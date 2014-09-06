class SpeedLimitedCar: Car
{
	// Make sure to specify the name and type
	override var speed: Double
	{
		get
		{
			return super.speed
		}
		// We need a setter since the super's property is read/write
		//
		// However, if the super was read-only, we wouldn't need this setter unless we wanted to
		// add write capability.
		set
		{
			super.speed = min(newValue, 40.0)
		}
	}
}