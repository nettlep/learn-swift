// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Automatic Reference Counting allows Swift to track and manage your app's memory usage. It
//   automatically frees up memory from unused instances that are no longer in use.
//
// * Reference counting only applies to classes as structures and enumerations are value types.
//
// * Whenever a class instance is stored (to a property, constant or variable) a
//   "strong reference" is made. A strong reference ensures that the reference is not deallocated
//   for as long as the strong reference remains.
// ------------------------------------------------------------------------------------------------

// We can't really see ARC in actino within a Playground, but we can still follow along what
// would normally happen.
//
// We'll start by creating a class to work with
class Person
{
	let name: String
	init (name: String)
	{
		self.name = name
	}
}

// We'll want to create a person and then remove our reference to it, which means we'll need to
// use an optional Person type stored in a variable:
var person: Person? = Person(name: "Bill")

// We now have a single strong reference to a single Person object.
//
// If we assign 'person' to another variable or constant, we'll increse the reference conunt by 1
// for a total of 2:
var copyOfPerson = person

// With a reference count of 2, we can set our original reference to nil. This will drop our
// reference count down to 1.
person = nil

// The copyOfPerson still exists and holds a strong reference to our instance:
copyOfPerson

// If we clear out this reference, we will drop the reference count once more to 0, causing the
// object to be cleaned up by ARC:
copyOfPerson = nil

// ------------------------------------------------------------------------------------------------
// Strong Reference Cycles between class instances
//
// If two classes hold a reference to each other, then they create a "Strong Reference Cycle".
//
// Here's an example of two classes that are capable of holding references to one another, but
// do not do so initially (their references are optional and defaulted to nil):
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

// We can create a tenant and an apartment which are not associated to each other. After these
// two lines of code, each instance will have a reference count of 1.
var bill: Tenant? = Tenant(name: "Bill")
var number73: Apartment? = Apartment(number: 73)

// Let's link them up.
//
// This will create a strong reference cycle because each instance will have a reference to the
// other. The end result is that each instance will now have a reference count of 2. For example,
// the two strong references for the Tenant instances are held by 'bill' and the 'tenant'
// property inside the 'number73' apartment.
//
// Note the "!" symbols for forced unwrapping (covered in an earlier section):
bill!.apartment = number73
number73!.tenant = bill

// If we try to clean up, the memory will not be deallocated by ARC. Let's follow along what
// actually happens a step at a time.
//
// First, we set 'bill' to be nil, which drops the strong reference count for this instance of
// Tenant down to 1. Since there is still a strong reference held to this instance, it is never
// deallocated (and the deinit() is also never called on that instance of Person.)
bill = nil

// Next we do the same for 'number73' dropping the strong reference count for this instance of
// Apartment down to 1. Similarly, it is not deallocated or deinitialized.
number73 = nil

// At this point, we have two instances that still exist in memory, but cannot be cleaned up
// because we don't have any references to them in order to solve the problem.

// ------------------------------------------------------------------------------------------------
// Resolving Strong Reference Cycles between Class Instances
//
// Swift provides two methods to resolve strong reference cycles: weak and unowned references.

// ------------------------------------------------------------------------------------------------
// Weak references allow an instance to be held without actually having a strong hold on it (and
// hence, not incrementing the reference count for the target object.)
//
// Use weak references when it's OK for a reference to become nil sometime during its lifetime.
// Since the Apartment can have no tenant at some point during its lifetime, a weak reference
// is the right way to go.
//
// Weak references must always be optional types (because they may be required to be nil.) When
// an object holds a weak reference to an object, if that object is ever deallocated, Swift will
// locate all the weak references to it and set those references to nil.
// 
// Weak references are declared using the 'weak' keyword.
//
// Let's fix our Apartment class. Note that we only have to break the cycle. It's perfectly
// fine to let the Tenant continue to hold a strong reference to our apartment. We will also
// create a new Tenant class (we'll just give it a new name, "NamedTenant"), but only so that we
// can change the apartment type to reference our fixed Apartment class.
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

// Here is our new tenant and his new apartment.
//
// This will create a single strong reference to each:
var jerry: NamedTenant? = NamedTenant(name: "Jerry")
var number74: FixedApartment? = FixedApartment(number: 74)

// Let's link them up like we did before. Note that this time we're not creating a new strong
// reference to the NamedTenant so the reference count will remain 1. The FixedApartment
// however, will have a reference count of 2 (because the NamedTenant will hold a strong reference
// to it.)
jerry!.apartment = number74
number74!.tenant = jerry

// At this point, we have one strong reference to the NamedTenant and two strong references to
// FixedApartment.
//
// Let's set jerry to nil, which will drop his reference count to 0 causing it to get
// deallocated. Once this happens, it is also deinitialized.
jerry = nil

// With 'jerry' deallocated, the strong reference it once held to FixedApartment is also cleaned
// up leaving only one strong reference remaining to the FixedApartment class.
//
// If we clear 'number74' then we'll remove the last remaining strong reference:
number74 = nil

// ------------------------------------------------------------------------------------------------
// Unowned References
//
// Unowned refernces are similar to weak references in that they do not hold a strong reference
// to an instance. However, the key difference is that if the object the reference is deallocated
// they will not be set to nil like weak references to. Therefore, it's important to ensure that
// any unowned references will always have a value. If this were to happen, accessing the unowned
// reference will trigger a runtime error. In fact, Swift guraantees that your app will crash in
// this scenario.
//
// Unowned references are created using the 'unowned' keyword and they must not be optional.
//
// We'll showcase this with a Customer and Credit Card. This is a good example case because a
// customer may have the credit card, or they may close the account, but once a Credit Card
// has been created, it will always have a customer.
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

// ------------------------------------------------------------------------------------------------
// Unowned References and Implicitly Unwrapped Optional Properties
//
// We've covered two common scenarios of cyclic references, but there is a third case. Consider
// the case of a country and its capital city. Unlike the case where a customer may have a credit
// card, or the case where an apartment may have a tenant, a country will always have a capital
// city and a capital city will always have a tenant.
//
// The solution is to use an unowned property in one class and an implicitly unwrapped optional
// property in the other class. This allows both properties to be accessed directly (without
// optional unwrapping) once initialization is complete, while avoiding the reference cycle.
//
// Let's see how this is done:
class Country
{
	let name: String
	let capitalCity: City!
	
	init(name: String, capitalName: String)
	{
		self.name = name
		self.capitalCity = City(name: capitalName, country: self)
	}
}

class City
{
	let name: String
	unowned let country: Country

	init(name: String, country: Country)
	{
		self.name = name
		self.country = country
	}
}

// We can define a Country with a capital city
var america = Country(name: "USA", capitalName: "Washington DC")

// Here's how and why this works.
//
// The relationship between Customer:CreditCard is very similar to the relationship between
// Country:City. The two key differences are that (1) the country initializes its own city and the
// country does not need to reference the city through the optional binding or forced unwrapping
// because the Country defines the city with the implicitly unwrapped optional property (using the
// exclamation mark on the type annotation (City!).
//
// The City uses an unowned Country property in the same way (and for the same reasons) as the
// CreditCard uses an unowned property of a Customer.
//
// The Country still uses an optional (though implicitly unwrapped) for the same reason that the
// Customer uses an optional to store a CreditCard. If we look at Country's initializer, we see
// that it initializes a capitalCity by passing 'self' to the City initializer. Normally, an
// initializer cannot reference its own 'self' until it has fully initialized the object. In this
// case, the Country can access its own 'self' because once 'name' has been initialized, the object
// is considered fully initialized. This is the case because 'capitalCity' is an optional.
//
// We take this just a step further by declaring 'capitalCity' to be an implicitly unwrapped
// optinoal property so that we can avoid having to deal with unwrapping 'capitalCity' whenever we
// want to access it.

// ------------------------------------------------------------------------------------------------
// Strong Reference Cycles for Closures
//
// We've seen how classes can reference each other creating a cyclic reference because classes are
// reference types. However, classes aren't the only way to create a cyclic reference. These
// problematic references can also happen with closures because they, too, are reference types.
//
// This happens when a closure captures an instance of a class (simply because it uses the class
// reference within the closure) and a class maintains a reference to the closure. Note that the
// references that a closure captures are automatically strong references.
//
// Let's see how this problem can manifest. We'll create a class that represents an HTML element
// which includes a variable (asHTML) which stores a reference to a closure.
//
// Quick note: The asHTML variable is defined as lazy so that it can reference 'self' within the
// closure. Try removing the 'lazy' and you'll see that you get an error trying to access 'self'.
// This is an error because we're not allowed to access 'self' during Phase 1 initialization. By
// making 'asHTML' lazy, we solve this problem by deferring its initialization until later.
class HTMLElement
{
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String =
	{
		if let text = self.text
		{
			return "<\(self.name)>\(text)</\(self.name)>"
		}
		else
		{
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil)
	{
		self.name = name
		self.text = text
	}
}

// Let's use the HTMLElement. We'll make sure we declare it as optional so we can set it to 'nil'
// later.
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "Hello, world")
paragraph!.asHTML()

// At this point, we've created a strong reference cycle between the HTMLElement instance and the
// asHTML closure because the closure references the object which owns [a reference to] it.
//
// We can set paragraph to nil, but the HTMLElement will not get deallocated:
paragraph = nil

// The solution here is to use a "Closure Capture List" as part of the closure's definition. This
// essentially allows us to modify the default behavior of closures using strong references for
// captured instances.
//
// Here's how we define a capture list:
//
//	lazy var someClosure: (Int, String) -> String =
//	{
//		[unowned self] (index: Int, stringToProcess: String) -> String in
//
//		// ... code here ...
//	}
//
// Some closures can used simplified syntax if their parameters are inferred while other closures
// may not have any parameters. In both cases the method for declaring the capture list doesn't
// change much. Simply include the capture list followed by the 'in' keyword:
//
//	lazy var someClosure: () -> String =
//	{
//		[unowned self] in
//
//		// ... code here ...
//	}
//
// Let's see how we can use this to resolve the HTMLElement problem. We'll create a new class,
// FixedHTMLElement which is identical to the previous with the exception of the addition of the
// line: "[unowned self] in"
class FixedHTMLElement
{
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String =
	{
		[unowned self] in
		if let text = self.text
		{
			return "<\(self.name)>\(text)</\(self.name)>"
		}
		else
		{
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil)
	{
		self.name = name
		self.text = text
	}
}

// Playgrounds do not allow us to test/prove this, so feel free to plug this into a compiled
// application to see it in action.
