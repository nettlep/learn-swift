class LinearCongruentialGenerator: RandomNumberGenerator
{
	var lastRandom = 42.0
	var m = 139956.0
	var a = 3877.0
	var c = 29573.0
	func random() -> Double
	{
		lastRandom = ((lastRandom * a + c) % m)
		return lastRandom / m
	}
}
let generator = LinearCongruentialGenerator()
generator.random()
generator.random()
generator.random()