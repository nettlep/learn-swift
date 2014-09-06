class Tenant
{
	let name: String
	var apartment: Apartment?

	init(name: String) { self.name = name }
}
class Apartment
{
	let number: Int
	var tenant: Tenant?

	init (number: Int) { self.number = number }
}