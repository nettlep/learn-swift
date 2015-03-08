// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 字典(Dictionary)儲存了相同型別的多個值，每一個在字典裡頭的值都關聯了一個作用類似於識別碼的鍵值
//
// * 字典是型別安全的，而且它們包含的元素型別必須明確
//
// * 能夠儲存在字典型別的元素型別必須明確，要嘛是透過顯示地做型別註解指定型別，要嘛是透過型別自動推斷
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// 創建一個字典
//
// 這是創建一個字典的語法。包含了一個使用逗號分隔開的一系列"鍵:值"對：
["TYO": "Tokyo", "DUB": "Dublin"]

// 讓我們使用這個語法來定義並初始化一個字典
//
//
// 在這個例子之中，我們使用型別註解來顯式地宣告一個擁有 String 型別的鍵與值的字典。這裡使用了
// "[ 鍵型別 : 值型別 ]" 的語法糖來宣告一個字典
var airports: [String : String] = ["TYO": "Tokyo", "DUB": "Dublin", "APL": "Apple Intl"]

// 上面那個宣告 airports 的方式也能使用這個方式宣告：
var players: Dictionary<String, String> = ["Who" : "First", "What" : "Second"]

// 下面的例子中，表達式只包含了 String 型別的鍵與值，所以使用型別自動推斷對我們有利，省了做型別註解的麻煩：
let inferredDictionary = ["TYO": "Tokyo", "DUB": "Dublin"]

// ------------------------------------------------------------------------------------------------
// 存取並修改一個字典
//
// 讓我們從 airport 這個字典中取得關聯到 TYO 鍵的值：
airports["TYO"]

// 如果試著從字典中取得一個不存在的值會發生什麼事？
//
// 因為這確實會發生，所以字典總是回傳一個可選型別(Optional)，在下面這一行程式碼裡頭，notFound 的值將會
// 是 nil。它也是一個 String? 的型別
var notFound = airports["FOO"]

// 我們可以取得字典中元素的數目：
airports.count

// 我們可以藉著設定一個不存在的鍵為它相應的值來增加一個元素：
airports["LHR"] = "London"

// 這裡是設定/更新一個值的另外一個方法。這個方式會在設定新的值以前，先取得這個值原先的內容，因為有可能取代
// 的過程不成功，所以回傳的是可選型別
var previousValue = airports.updateValue("Dublin International", forKey: "DUB")

// 我們可以藉由將字典任一個鍵的值設為 nil 來移除這對元素：
airports["APL"] = nil

// 這裡是移除一對鍵與值的另外一個方法。方法回傳的值是傳入那個鍵相應的值。一樣，這裡回傳的也是可選型別，以
// 避免傳入的鍵沒有相應的值可以移除。在這個例子中，APL 這個鍵先前就已經移除了，所以回傳的就是一個值為 nil
// 的可選型別
var removedValue = airports.removeValueForKey("APL")

// ------------------------------------------------------------------------------------------------
// 迭代一個字典
//
// 我們可以使用 for-in 的語法來迭代字典中的每一組鍵值對，然後再將使用元組來儲存這個字典中的每一組鍵值對
for (airportCode, airportName) in airports
{
	airportCode
	airportName
}

// 我們可以只迭代字典中的鍵
for airportCode in airports.keys
{
	airportCode
}

// 我們可以只迭代字典中的值
for airportName in airports.values
{
	airportName
}

// 我們可以從字典的鍵值對中創建一個陣列
//
// 請留意當我們這麼做的時候，必須使用 Array() 這個語法來將字典中的鍵或值轉型為陣列
var airportCodes = Array(airports.keys)
var airportNames = Array(airports.values)

// ------------------------------------------------------------------------------------------------
// 創建一個空字典
//
// 我們在這裡創建了一個擁有 Int 型別的鍵與 String 型別的值的空字典
var namesOfIntegers = Dictionary<Int, String>()

//讓我們存入一組鍵值對
namesOfIntegers[16] = "Sixteen"

// 我們可以靠設定空字典的語法來清空一個字典
namesOfIntegers = [:]

// 一個不可變的字典是一個常數
let immutableDict = ["a": "one", "b": "two"]

// 類似陣列，我們不能修改不可變字典的內容。下方這兩行程式碼無法編譯：
//
// immutableDict["a"] = "b" // 你不能修改內容元素
// immutableDict["c"] = "three" // 你不能透過增加新元素來改變字典的大小

// 字典是值型別，這表示它們在賦值的過程中做了複製的動作
//
// 讓我們創建一個字典然後複製它：
var ages = ["Peter": 23, "Wei": 35, "Anish": 65, "Katya": 19]
var copiedAges = ages

// 接下來，我們修改原本字典的複製
copiedAges["Peter"] = 24

// 然後我們可以發現原本字典不受影響，沒有改變：
ages["Peter"]

