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
					return Values(first: self.toRaw(), second: nil)
			}
		}
	}
	
	// BlackjackCard properties and methods
	let rank: Rank
	let suit: Suit
	
	var description: String
	{
		var output = "A \(suit.toRaw()) with a value of \(rank.values.first)"
		if let second = rank.values.second
		{
			output += " or \(second)"
		}
		return output
	}
}