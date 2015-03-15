// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * Swift 提供一個建構器(initializer, 有點像函式)來確保類別、結構或列舉中的每個屬性都被初始化了
//
// * 可選型別不需要初始化，因為如果沒給它們默認值的話，它們會被自動初始化為 nil
// ------------------------------------------------------------------------------------------------

// 這裡是建構器的基本使用方式
//
// Fahrenheit 類別將創建一個沒有默認值的 'temperature' 屬性。因為沒有默認值，這個屬性必須在建構器中被初始化
//
// 如果沒有替這個類別加上建構器，我們會在試著實體化 Fahrenheit 類別的時候，得到一個編譯錯誤
struct Fahrenheit
{
	var temperature: Double

	init()
	{
		temperature = 32.0
	}
}

// 因為這個類別已被完全的初始化，我們可以順利地將它實體化：
var f = Fahrenheit()

// 因為 temperature 屬性總是被設置為 "32.0"，因此比較建議而且更加清楚的做法是直接將它的默認值設置為 32.0，而不是
// 在建構器中將它初始化
struct AnotherFahrenheit
{
	var temperature: Double = 32.0
}

// 建構器也可以包含參數。這兒有一個使用了參數的建構器例子，它使用傳進去的參數來替類別的 temperature 屬性初始化：
//
// 下面的類別包含了兩種建構器：
struct Celsius
{
	var temperatureInCelsius: Double = 0.0
	
    // 基於 Fahrenheit 的值來初始化 temperature
	init(fromFahrenheit fahrenheit: Double)
	{
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8
	}
	
    // 基於 Kelvin 的值來初始化 temperature
	init(kelvin: Double)
	{
		temperatureInCelsius = kelvin - 273.15
	}
}

// 現在讓我們來試試新的建構器
let boilingPotOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(kelvin: 273.15)

// 建構器會自動產生外部參數名稱。你可以在外部參數上顯式地使用 "_" 符號來避免這個自動產生外部參數名稱的行為：
//
// 這兒是一個定義了兩種建構器的類別 - 一個使用自動產生的外部參數名稱，另一個不使用外部參數名稱：
struct Color
{
	var red = 0.0, green = 0.0, blue = 0.0
	
    // 建構器將自動產生外部參數名稱
	init(red: Double, green: Double, blue: Double)
	{
		self.red = red
		self.green = green
		self.blue = blue
	}
	
    // 這個建構器在外部參數上顯式地使用 "_" 符號來避免使用外部參數名稱
	init(_ red: Double, _ blue: Double)
	{
		self.red = red
		self.green = 0
		self.blue = blue
	}
}

// 這兒，我們可以看到修改已經生效：
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let purple = Color(1.0, 0.5)

// 可選型別不需要被初始化：
class SurveyQuestion
{
	var text: String
	
    // response 屬性是可選型別，它會自動初始化為 nil
	var response: String?

	init(text: String)
	{
        // 我們只需要初始化 'text' 屬性
		self.text = text
	}
	
	func ask() -> String
	{
		return text
	}
}

// 常數也必須初始化。在下面的範例中，我們的常數 text1 有默認值，常數 text2 沒有默認值：
class SurveyQuestion2
{
    // 默認值是 "No question"
	let text1: String = "No question"
    let text2: String
	
	var response: String?
	
    init(text: String, response: String)
	{
        // 無法對已經賦值的常數重複賦值，此行無法編譯
        // self.text1 = text

        // 還沒賦值的常數可以在建構器中賦值
		self.text2 = text
        self.response = response
	}
	
	init()
	{
        // 如果這個建構式什麼也不做，會無法通過編譯，因為常數 text2 沒有默認值
        self.text2 = ""
	}
	
	func ask() -> String
	{
		return text2
	}
}

// 這兒，我們可以使用空白的建構器來初始化這個類別(呼叫 init())。讓 'text1' 屬性的默認值來初始化它的儲存值，
// 'text2' 屬性會設定為空字串 ""
let noQuestion = SurveyQuestion2()

// 這兒，我們使用另一個建構器來初始化類別中的所有屬性：
let beetsQuestion = SurveyQuestion2(text: "Do you like beets?", response: "Yes, I do!")
// 變數 response 與常數 text2 在建構器中修改成功，但常數 text1 無法重複賦值
beetsQuestion

// ------------------------------------------------------------------------------------------------
// 默認建構器
//
// 如果所有的屬性都有默認值(包含可選型別的自動默認值 nil)，加上你沒有創建自己的建構器，加上這個類別不繼承任何父類別
// ，Swift 會幫你創建默認的建構器(沒有任何參數)。這個建構器將所有的屬性初始化為它們的默認值。
//
// 如果你創建了自己的建構器，Swift 就不會自動創建默認建構器。如果你不只想要自定義的建構器，也想要默認建構器，那麼就
// 將你自己的建構器放在擴展(extension)中(以後的章節會談)
class ShoppingListItem
{
	var name: String?
	var quantity = 1
	var purchased = false
	
    // 不需要自定義 init(...) 建構器，因為會自動創建
}

// ------------------------------------------------------------------------------------------------
// 結構型別中針對個別成員的建構器
//
// 就像類別中的建構器，一個沒有實作自定義建構器，但所有屬性都有默認值的結構，會自動產生一個針對個別成員的建構器
//
// 跟類別相同，如果你不只想要自定義的建構器，也想要默認的針對個別成員的建構器，就將你自己的建構器放在擴展中
struct Size
{
	var width = 0.0
	var height = 0.0
}

// 在這兒，我們呼叫 Swift 替我們自動產生的針對個別成員的建構器
let twoByTwo = Size(width: 2.0, height: 2.0)

// ------------------------------------------------------------------------------------------------
// 值型別的代理建構器
//
// 有時候，擁有呼叫其他建構器來幫助我們做初始化的多個建構器是很方便的
//
// 在下面的例子中，'Rect' 是一個擁有多個建構器的結構。其中一個建構器使用傳入的 origin 以及 size 來初始化結構，
// 另一個建構器，使用傳入的 center 以及 size 計算出 origin 之後，再呼叫 origin 以及 size 的建構器來初始化結構
//
// 之後的 "建構器鏈" 章節中會對這個概念做進一步的延伸
struct Point
{
	var x = 0.0
	var y = 0.0
}

struct Rect
{
	var origin = Point()
	var size = Size()
	
    // 我們創建了一個使用默認值來初始化的基本建構器。因為我們定義了別的建構器，所以系統不會自動幫我們創建這個基本建構
    // 器，因此我們必須自行定義。既然使用默認值為屬性做初始化，所以這個基本建構器裡頭什麼也不用做
	init() {}
	
    // 使用 origin/size 來初始化
	init(origin: Point, size: Size)
	{
		self.origin = origin
		self.size = size
	}
	
    // 從 center/size 來初始化 - 注意我們是如何使用 init(origin: Point, size: Size) 來執行實際的初始化過程
	init(center: Point, size: Size)
	{
		let originX = center.x - size.width / 2
		let originY = center.y - size.height / 2
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}

// 我們在這兒分別呼叫三種不同的建構器：
let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
