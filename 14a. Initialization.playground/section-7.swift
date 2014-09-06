struct Celsius
{
	var temperatureInCelsius: Double = 0.0
	
	// Initialize our temperature from Fahrenheit
	init(fromFahrenheit fahrenheit: Double)
	{
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8
	}
	
	// Initialize our temperature from Kelvin
	init(kelvin: Double)
	{
		temperatureInCelsius = kelvin - 273.15
	}
}