// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Nested types are utility classes and structures that are declared within other classes,
//   structures and enumerations.
// ------------------------------------------------------------------------------------------------

// Let's take a look at how we might define a Blackjack Card using nested types.
//
// Each card has a suit (Spades, Hearts, Diamonds, Clubs) and a rank (Ace, King, Queen, etc.) This
// is a natural use of nested types because the suit and rank enumerations only apply to a
// Blackjack card and so they are scoped to within that that type.
//
// Additionally, since the rank of an Ace can be valued at either an 11 or a 1, we can create
// a nested structure within the Rank enumeration that allows us to multiple values for a given
// rank.
//
// Let's see how this might be implemented:
struct BlackjackCard
{
	// Nested Suit enumeration
	enum Suit: Character
	{
		case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
	}
	
	// Nested Rank enumeration
	enum Rank: Int
	{
		case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
		case Jack, Queen, King, Ace
		
		// A rank can possibly have two values (for the Ace), so we'll use this structure
		// to contain those two values. We could just as well use a Tuple, but we're showcasing
		// nested types.
		//
		// Note that since all Ranks have a value but only some ranks have a second value, we'll
		// define the first value as an Int and the second value as an Int?
		struct Values
		{
			let first: Int
			let second: Int?
		}

		// Here we have a computed property to return the values of a rank. Note that the only
		// Rank to return multiple values is the Ace. However, we also use this to provide the
		// proper value for Jack/King/Queen, which are all equivalent to 10.
		var values: Values
		{
			switch self
			{
				case .Ace:
					return Values(first: 1, second: 11)
				case .Jack, .Queen, .King:
					return Values(first: 10, second: nil)
				default:
					return Values(first: self.rawValue, second: nil)
			}
		}
	}
	
	// BlackjackCard properties and methods
	let rank: Rank
	let suit: Suit
	
	var description: String
	{
		var output = "A \(suit.rawValue) with a value of \(rank.values.first)"
		if let second = rank.values.second
		{
			output += " or \(second)"
		}
		return output
	}
}

// Let's initialize a BlackJack card for the Ace of Spades. Note that BlackjackCard doesn't define
// any initializers, so we're able to use the default memberwise initializer.
//
// Also note that since the initializer knows thet type of each member being initialized (both of
// which are enumerations) we can use the shorthand method (.Something) for each member's initial
// value.
let theAceOfSpades = BlackjackCard(rank: .Ace, suit: .Spades)
theAceOfSpades.description

// To access the nested type, we can drill down into the type using type names:
let heartsSymbol = String( BlackjackCard.Suit.Hearts.rawValue )
