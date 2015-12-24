// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Enumerations in Swift are different from their popular counterparts in C-like languages.
//   Rather that containing "one of a set of integer values" like most C-like languages, Swift's
//   enumerations can be thought of as holding one named type of a given set of named types.
//
//   To clarify: Rather than holding an integer value that has been pre-defined integer value
//   (Error = -1, Success = 0) an enumeration in Swift only associates a name with a type (like
//   Int, String, Tuple, etc.) These elements of the enumeration can then be assigned "Associated
//   Values." For example, an enumeration can store an "Error" which is a Tuple with an Int value
//   for the error code and a String containing the message. Each time a function or piece of code
//   assignes or returns an Error(Int, String), it can set populate the Tuple with Int/String par
//   for the specific error condition.
//
// * Alternative to the enumeration storing named types, Swift enumerations can have a type. If
//   that type is Int, then they will behave more like their C-style counterparts.
// ------------------------------------------------------------------------------------------------

// Here is the simple enumeration.
//
// Unlike their C counterparts, the members of the enumeration below are not integer values (0,
// 1, 2, etc.) Instead, each member is a fully-fledged value in its own right.
enum Planet
{
	case Mercury
	case Venus
	case Earth
	case Mars
	case Jupiter
	case Saturn
	case Uranus
	case Neptune
}

// You can also combine members onto a single line if you prefer, or mix them up. This has no
// effect on the enumeration itself.
enum CompassPoint
{
	case North, South
	case East, West
}

// Let's store an enumeration value into a variable. We'll let the compiler infer the type:
var directionToHead = CompassPoint.West

// Now that directionToHead has a CompassPoint type (which was inferred) we can set it to a
// different CompassPoint value using a shorter syntax:
directionToHead = .East

// We can use a switch to match values from an enumeration.
//
// Remember that switches have to be exhaustive. But in this case, Swift knows that the CompassType
// enumeration only has 4 values, so as long as we cover all 4, we don't need the default case.
switch directionToHead
{
	case .North:
		"North"
	case .South:
		"South"
	case .East:
		"East"
	case .West:
		"West"
}

// ------------------------------------------------------------------------------------------------
// Associated Values
//
// Associated values allows us to store information with each member of the switch using a Tuple.
//
// The following enumeration will store not only the type of a barcode (UPCA, QR Code) but also
// the data of the barcode (this is likely a foreign concept for most.)
enum Barcode
{
	case UPCA(Int, Int, Int) // UPCA with associated value type (Int, Int, Int)
	case QRCode(String)      // QRCode with associated value type of String
}

// Let's specify a UPCA code (letting the compiler infer the enum type of Barcode):
var productBarcode = Barcode.UPCA(0, 8590951226, 3)

// Let's change that to a QR code (still of a Barcode type)
productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

// We use a switch to check the value and extract the associated value:
switch productBarcode
{
	case .UPCA(let numberSystem, let identifier, let check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	case .QRCode(let productCode):
		"QR: \(productCode)"
}

// Using the switch statement simplification (see the Switch statement section) to reduce the
// number of occurrances of the 'let' introducer:
switch productBarcode
{
	// All constants
	case let .UPCA(numberSystem, identifier, check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	
	// All variables
	case var .QRCode(productCode):
		"QR: \(productCode)"
}

// ------------------------------------------------------------------------------------------------
// Raw values
//
// We can assign a type to an enumeration. If we use Int as the type, then we are effectively
// making an enumeration that functions like its C counterpart:
enum StatusCode: Int
{
	case Error = -1
	case Success = 9
	case OtherResult = 1
	case YetAnotherResult // Unspecified values are auto-incremented from the previous value
}

// We can get the raw value of an enumeration value with the rawValue member:
StatusCode.OtherResult.rawValue

// We can give enumerations many types. Here's one of type Character:
enum ASCIIControlCharacter: Character
{
	case Tab = "\t"
	case LineFeed = "\n"
	case CarriageReturn = "\r"
	
	// Note that only Int type enumerations can auto-increment. Since this is a Character type,
	// the following line of code won't compile:
	//
	// case VerticalTab
}

// Alternatively, we could also use Strings
enum FamilyPet: String
{
	case Cat = "Cat"
	case Dog = "Dog"
	case Ferret = "Ferret"
}

// And we can get their raw value as well:
FamilyPet.Ferret.rawValue

// We can also generate the enumeration value from the raw value. Note that this is an optional
// because not all raw values will have a matching enumeration:
var pet = FamilyPet(rawValue: "Ferret")

// Let's verify this:
if pet != .None { "We have a pet!" }
else { "No pet :(" }

// An example of when a raw doesn't translate to an enum, leaving us with a nil optional:
pet = FamilyPet(rawValue: "Snake")
if pet != .None { "We have a pet" }
else { "No pet :(" }

