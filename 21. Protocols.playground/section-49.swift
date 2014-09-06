@objc protocol HasArea
{
	var area: Double { get }
}

class Circle: HasArea
{
	let pi = 3.14159
	var radius: Double
	var area: Double { return pi * radius * radius }
	init(radius: Double) { self.radius = radius }
}
class Country: HasArea
{
	var area: Double
	init(area: Double) { self.area = area }
}
class Animal
{
	var legs: Int
	init(legs: Int) { self.legs = legs }
}