// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 解構器在類別實體所佔據的記憶體空間被釋放之前會被自動呼叫，所以在解構器中，可以存取所有的屬性
//
// * 你不能直接呼叫它們
//
// * 解構器的呼叫順序，父類別優先於子類別
//
// * Swift 使用自動參考計數(ARC)來管理記憶體，所以不應依賴解構器。然而，你或許需要在一個類別實體的生命週期結束之
//   前，關閉你先前開啟的檔案控制器
// ------------------------------------------------------------------------------------------------

// 讓我們創建兩個類別來試試解構器...
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
	
    // 這個 Player 類別的解構器做的事，就是在 Player 實體的生命週期結束前，將硬幣存回銀行
	deinit
	{
		Bank.receiveCoins(coinsInPurse)
	}
}

// 讓我們使用 Player 類別創建一個錢包裡頭有 100 個硬幣的玩家(從銀行領出來)
var playerOne: Player? = Player(coins: 100)
playerOne!.coinsInPurse
Bank.coinsInBank

// 這個玩家贏得了 2000 個硬幣！
playerOne!.winCoins(2_000)
playerOne!.coinsInPurse
Bank.coinsInBank

// 當我們主動結束這個玩家類別實體的生命週期時，解構器會被自動呼叫
playerOne = nil

// 現在銀行裡頭有 12000 枚硬幣(2100 + 9900)
Bank.coinsInBank
