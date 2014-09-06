class NamedTenant
{
	let name: String
	var apartment: FixedApartment?
	
	init(name: String) { self.name = name }
}
class FixedApartment
{
	let number: Int
	weak var tenant: NamedTenant?
	
	init (number: Int) { self.number = number }
}