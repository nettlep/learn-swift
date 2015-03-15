// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 建構器鏈指發生在類別階層中的建構過程
//
// * 指定建構器確保類別、結構或列舉中的屬性都被初始化了，截至目前為止見到的都是指定建構器。指定建構器也要負責呼叫
//   父類別的建構器
//
// * 便利建構器提供特定的初始化過程，為了滿足完整初始化一個類別的需求，便利建構器必須呼叫同類別中的指定建構器
// ------------------------------------------------------------------------------------------------

// 截至目前為止，你看過的一般建構器 "init(...)" 都是指定建構器。如果系統幫你創建了一個默認的建構器，它也會是指定
// 建構器
//
// 便利建構器允許你透過呼叫其他的指定建構器，在建構過程中提供不同的程式碼路徑。它們使用的是 convenience 這個關鍵
// 字。實際上它們不同於指定建構器，因為 Swift 使用了不同的關鍵字來表示我們即將提到的兩段式建構過程
//
// 這兒是一個擁有指定建構器以及便利建構器的的基本類別：
class Food
{
	var name: String

    // 指定建構器 - 如果沒有給予 'name' 屬性默認值，那就需要一個指定建構器。雖然可以擁有多個指定建構器，但通常越
    // 少越好 - 明智地規劃你的設計
	init(name: String)
	{
		self.name = name
	}
	
    // 我們使用便利建構器來初始化 'name' 屬性為 "[unnamed]“
	convenience init()
	{
        // 必須呼叫同一類別中的指定建構器
		self.init(name: "[unnamed]")
	}
}

// 我們在這兒呼叫這兩個建構器
let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()

// ------------------------------------------------------------------------------------------------
// 兩段式建構過程
//
// 兩段式建構過程是 Swift 程式語言中的新概念，它運作的方式像這樣：
//
// 階段一：子類別首先必須初始化任何屬於這個子類別的儲存屬性。在它們被允許更動父類別的儲存屬性之前，必須先完成這個動
//        作
//
//        然後子類別必須呼叫它父類別的建構器，重複這個過程直到最頂端的父類別(基礎類別)
//
//        至此我們可以假設這個類別已經初始化完成了(但可能還需要更改初始化的值為其他自定義的值)
//
// 階段二：在基礎類別的建構器中，我們可以在將這些屬性值回傳給子類別以前，先使用指定建構器來自定義它們的值。然後這個
//        接收了自定義新值的子類別，也可以修改任何定義在它或它父類別繼承鏈中的屬性值，然後再將值回傳給這個子類別的
//        子類別，重複這個過程直到回到最底端的子類別。(一開始呼叫建構器的類別)
//
// 關於便利建構器的註解：
//
// 便利建構器必須呼叫同類別中的指定建構器。一個子類別的指定建構器也必須呼叫父類別的建構器，這個被呼叫的父類別建構器
// 可以是便利建構器，因為便利建構器終究必須在回到更上一層的父類別前，先呼叫指定建構器
//
// 讓我們從 Food 類別中，衍生一個 RecipeIngredient 類別，來看看這個兩段式建構過程的實際運作方式：
class RecipeIngredient: Food
{
	var quantity: Int
	
    // 這是一個指定建構器(因為它沒有 'convenience' 關鍵字)
	init(name: String, quantity: Int)
	{
        // 我們必須先初始化儲存值(這是階段一)
		self.quantity = quantity
		
        // 然後，我們必須呼叫父類別的建構器(仍然是階段一)
		super.init(name: name)
		
        // 只有當父類別的建構器被呼叫完畢後，我們才能開始自定義已建構完成類別中的屬性(階段二)
		self.name = "Ingredient: " + name
	}

    // 在這兒，我們創建了一個便利建構器，它的用途不過是提供 quantity 這個屬性一個 1 的默認值。為了通過編譯，留意
    // 我們需要呼叫指定建構器
	convenience override init(name: String)
	{
		self.init(name: name, quantity: 1)
	}
}

// 現在我們可以呼叫各個建構器，看看它們實際運作的狀況：
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

// ------------------------------------------------------------------------------------------------
// 完整繼承一個父類別中的建構器
//
// 在下面的類別中，我們不指定任何建構器，這不成問題，因為所有的屬性都有它們自己的默認值
//
// 沒提供自定義的建構器，讓這個類別擁有從父類別中繼承的全部建構器
class ShoppingListItem: RecipeIngredient
{
	var purchased = false
	var description: String
	{
		var output = "\(quantity) x \(name)"
		output += purchased ? " ✔" : " ✘"
		return output
	}
}

// 讓我們使用父類別的建構器來初始化這個 ShoppingListItem 類別
let lotsOfCheese = ShoppingListItem(name: "cheese", quantity: 99)

// 我們可以創建一個 ShoppingListItem 類別的陣列
var breakfastList = [
	ShoppingListItem(),
	ShoppingListItem(name: "Bacon"),
	ShoppingListItem(name: "Eggs", quantity: 6),
]

// ------------------------------------------------------------------------------------------------
// 對於個別屬性來說，與其直接使用表達式來設定它們的值，我們也可以使用閉包或函式來設定這些屬性的默認值
//
// 在下面的例子中，我們使用一個閉包來為 'estimatedPi' 屬性計算默認值。請留意在閉包結尾處的那一對括號。如果移除了這對
// 括號，編譯器會要求我們將 'estimatedPI' 屬性設置為閉包型別，而不是閉包的執行結果。此外，這對括號也表示馬上執行這個
// 閉包
//
// 也請留意這個用來設置此屬性默認值的閉包，並不允許存取同類別中的其他屬性，因為那些屬性會被假設尚未完成初始化
class ClassWithPI
{
	let estimatedPI: Double =
	{
		let constant1 = 22.0
		let constant2 = 7.0
		
        // 必須回傳這個屬性被指定的型別
		return constant1 / constant2
	}()
}

// 這裡有個更實用的例子。因為閉包的回傳值，必須是這個正在被初始化的屬性的型別，所以必須創建一個同型別的暫存變數，將它
// 初始化後再回傳以對屬性賦值
struct CheckerBoard
{
	let boardColors: [Bool] =
	{
		var temporaryBoard = [Bool]()
		var isBlack = false
		for i in 1...10
		{
			for j in 1...10
			{
				temporaryBoard.append(isBlack)
				isBlack = !isBlack
			}
			
			isBlack = !isBlack
		}
		
        // 回傳這個暫存變數以設定 'boardColors' 的值
		return temporaryBoard
	}()
	
	func squareIsBlackAtRow(row: Int, column: Int) -> Bool
	{
		return boardColors[(row * 10) + column]
	}
}

// 現在來檢查一下結果
var board = CheckerBoard()
board.squareIsBlackAtRow(1, column: 1) // 應該是 false
board.squareIsBlackAtRow(1, column: 2) // 應該是 true
