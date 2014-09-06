class Customer
{
	let name: String
	var card: CreditCard?
	init (name: String)
	{
		self.name = name
	}
}

class CreditCard
{
	let number: Int
	unowned let customer: Customer
	
	// Since 'customer' is not optional, it must be set in the initializer
	init (number: Int, customer: Customer)
	{
		self.number = number
		self.customer = customer
	}
}