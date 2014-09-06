class Dice
{
	let sides: Int
	let generator: RandomNumberGenerator
	init(sides: Int, generator: RandomNumberGenerator)
	{
		self.sides = sides
		self.generator = generator
	}
	
	func roll() -> Int
	{
		return Int(generator.random() * Double(sides)) + 1
	}
}