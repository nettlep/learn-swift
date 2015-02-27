// ------------------------------------------------------------------------------------------------
// 本篇須知:
//
// * 一個可選型別表示一種裡頭可以儲存一個值或者是 "什麼也沒有" 的變數
//
// * 這很像將一個 "nil" 值賦值給變數，但可選型別可以使用在包括 Int, Bool 等等的任何型別上
// ------------------------------------------------------------------------------------------------

// 一個可選型別的宣告會在顯式地指定型別後方加上一個 "?"。以下這一行宣告了一個叫做 'someOptional' 的
// 可選型別，這個變數裡頭要不是儲存了一個 Int 變數，就是什麼也沒有。在此例子中，我們可以將一個可選的 Int
// 型別變數設為 .None(意義就像是 nil)
let someOptional: Int? = .None

// 讓我們試著將一個 String 轉為 Int
//
// 使用字串型別提供的 toInt() 方法，我們可以試著將一個字串轉為一個數值型別，因為不是所有的字串都能轉換為整數，
// 這個 toInt() 方法會回傳一個可選型別 "Int?"。我們能夠藉著這個結果來分辨轉換成功與否，而不需要去捕捉例外或是
// 靠其他神奇的方法來搞清楚轉換的結果。
//
// 這裡就是一個可選型別的實際操作方式
let notNumber = "abc"
let failedConversion = notNumber.toInt()

// 請注意 failedConversion 的值為 'nil'，即時它當初被轉換為 Int
failedConversion

// 讓我們繼續看一個轉換成功的例子
let possibleNumber = "123"
var optionalConvertedNumber = possibleNumber.toInt()

// 這個轉換是成功的
optionalConvertedNumber

// 如果我們將它賦值給一個常數，這個常數的型別將會是一個可選型別的 Int (Int?)
let unwrapped = optionalConvertedNumber // 'unwrapped' 是另一個可選型別

// ------------------------------------------------------------------------------------------------
// 其他使用可選型別的語法
//
// 使用在型別後方加上 "?" 的方式來代表可選型別，是定義在 Swift 標準函式庫中的泛型可選型別的語法糖。我們還未接觸到
// 泛型，但別因如此就讓我們在此忽略了這個小細節。
//
// 以下這兩行是相同的型別：
let optionalA: String? = .None
let optionalB: Optional<String> = .None

// ------------------------------------------------------------------------------------------------
// 解開
//
//
// 區分 Int 與 Int? 之間的不同是很重要的。可選型別實質上包裝了它的內容物，這代表了 Int 與 Int? 是完全不同的
// 兩個型別。(後者被包裝為可選型別)
//
// 我們不能顯式地將可選型別轉為 Int 因為它不等同於 Int?。下面這一行不能編譯：
//
// let unwrappedInt: Int = optionalConvertedNumber

// 做轉換的其中一種方法是使用 "!" 符號來 "強制解開" 被包裝在裡頭的值，例如：
let unwrappedInt = optionalConvertedNumber!

// 隱式地解開包裝不是那麼的可靠，因為可選型別裡頭可能什麼也沒有，這時候就會產生一個執行階段的錯誤。想確認解開
// 包裝的行為是安全的，你可以使用 if 表達式來判斷可選型別。
if optionalConvertedNumber != .None
{
    // 現在強制解開包裝就是安全的操作，因為我們 "確認過" 它有值
	let anotherUnwrappedInt = optionalConvertedNumber!
}
else
{
    // 這個可選型別儲存了 "什麼也沒有"
	"Nothing to see here, go away"
}

// ------------------------------------------------------------------------------------------------
// 可選綁定
//
// 我們可以在條件語句中，將可選型別賦值給一個儲存值來判斷可選型別是否有值
//
// 在以下的這個區塊中，我們將可選型別綁定到一個名為 'intValue' 的 Int 型別常數上
if let intValue = optionalConvertedNumber
{
    // 不需要使用 "!" 的後綴符號，因為 intValue 不是一個可選型別
	intValue
	
    // 事實上，因為 'intValue' 是一個 Int (不是 Int?)，所以不能強制解開。下面這一行程式碼不能編譯：
	// intValue!
}
else
{
    // 留意 'intValue' 不在這個 "else" 的範圍中
	"No value"
}

// 我們也可以將可選綁定使用在另一個可選型別上，如果我們打算這麼做，必須顯式地指定要被綁定的儲存值的型別：
if let optionalIntValue:Int? = optionalConvertedNumber
{
    // 'optionalIntValue' 依然是一個可選型別，但先前就已經知道它有值了。因為它是一個可選型別，所以
    // 我們仍可以在這邊再度確認。如果它不是，下面的這個 if 表達式無法編譯：
	if optionalIntValue != .None
	{
        // 'optionalIntValue' 是一個可選型別所以在這裡我們仍然使用強制解開：
		"intValue is optional, but has the value \(optionalIntValue!)"
	}
}

// 設定一個可選型別為 'nil' 表示將它設定為 "裡頭什麼也沒有"
optionalConvertedNumber = nil

// 當我們檢查它的時候，可以知道它確實沒有值：
if optionalConvertedNumber != .None
{
	"optionalConvertedNumber holds a value (\(optionalConvertedNumber))! (this should not happen)"
}
else
{
	"optionalConvertedNumber holds no value"
}

// 我們也能對一個可選綁定到空的可選型別的常數做測試
if let optionalIntValue = optionalConvertedNumber
{
	"optionalIntValue holds a value (\(optionalIntValue))! (this should not happen)"
}
else
{
	"optionalIntValue holds no value"
}

// 經過了以上對可選型別的介紹，你應該已經知道不能將 nil 值設給非可選型別的變數或常數。
//
// 以下的這一行不能編譯
//
// var failure: String = nil // 無法編譯

// 下面這一行可以編譯，因為 String 指定為可選型別
var noString: String? = nil

// 如果我們創建了一個沒有初始化的可選型別，它會自動被初始化為 nil。在接下來的小節中，我們會學到所有的值都必須先
// 被初始化後才能使用。因為這個行為，下面的這個變數會被認為已經被初始化了，即使它裡頭什麼也沒有：(nil)
var emptyOptional: String?

// 另一個隱式解開一個可選型別的方法是在宣告的時候指定一個值給它
//
// 在此，我們創建了一個確認它總是有值的可選型別，因此給予了 Swift 當需要的時候可以自動解開它的許可。
//
// 留意它的型別 "String!"
var assumedString: String! = "An implicitly unwrapped optional string"

// 雖然 assumedString 仍然是一個可選型別(而且可視為一個可選型別來處理)，它在當作一個普通字串使用的時候，
// 將自動被解開。
//
// 請留意，我們沒有使用 '!' 去解開這個可選變數是為了展示它能直接賦值給普通字串
let copyOfAssumedString: String = assumedString

// 因為 assumedString 是個可選型別，我們依然能夠將它設值為 nil。因為我們已經假設它總是有值，所以這個操作是危險的
// (而且已經給予 Swift 自動解開它的許可)！做這個操作是一個冒險的行為：
assumedString = nil

// "一定"要確認你隱式解開的可選型別是有值的！
//
// 下面這一行可以編譯，但會因為自動解開一個沒有值的可選型別，而產生一個執行階段錯誤
//
// let errorString: String = assumedString

// 就像任何一個可選型別，我們可以檢查它是否有值：
if assumedString != nil
{
	"We have a value"
}
else
{
	"No value"
}

