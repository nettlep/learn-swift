// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Deinitializers are called automatically before a class instance is
//   deallocated,so you can access all properties in the deinitializer.
//
// * You cannot call them directly.
//
// * The superclass' deinitializer is called before the subclass'.
//
// * Swift uses ARC to manage memory, so deinitializers shouldn't always
//   be necessary. However, you might open a file and need to close it
//   when a class is deallocated.
// ------------------------------------------------------------------------------------------------

// Let's create a couple classes to work with...
struct Bank
{
	static var coinsInBank = 10_000
	static func vendCoins(var numberOfCoinsToVend: Int) -> Int
	{
		numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
		coinsInBank -= numberOfCoinsToVend
		return numberOfCoinsToVend
	}
	
	static func receiveCoins(coins: Int)
	{
		coinsInBank += coins
	}
}

class Player
{
	var coinsInPurse: Int
	
	init(coins: Int)
	{
		coinsInPurse = Bank.vendCoins(coins)
	}
	
	func winCoins(coins: Int)
	{
		coinsInPurse += coins
	}
	
	deinit
	{
		Bank.receiveCoins(coinsInPurse)
	}
}

// Let's exercise the Player class a bit and create a new player with 100
// coins in his purse (pulled from the Bank.)
var playerOne: Player? = Player(coins: 100)
playerOne!.coinsInPurse
Bank.coinsInBank

// The Player now wins 2000 coins!
playerOne!.winCoins(2_000)
playerOne!.coinsInPurse
Bank.coinsInBank

// When we cause playerOne to be deallocated, the deinitializer is called
playerOne = nil

// This should print 12000 coins, but the playgrounds don't appear to do
// this correctly. If you put this code into a project and compile/run
// it (with minor changes to print variables using println) then you
// will see that the bank does indeed have 12000 coins.
Bank.coinsInBank
