extension Double
{
	var kmToMeters: Double { return self * 1_000.0 }
	var cmToMeters: Double { return self / 100.0 }
	var mmToMeters: Double { return self / 1_000.0 }
	var inchToMeters: Double { return self / 39.3701 }
	var ftToMeters: Double { return self / 3.28084 }
}