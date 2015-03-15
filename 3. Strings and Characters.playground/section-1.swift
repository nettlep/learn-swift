// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * String 型別完美地跟 NSString 類別橋接在一起
//
// * 所有的 String 型別都是萬國碼相容的
// ------------------------------------------------------------------------------------------------

// 這兒是一個字串
var str: String = "Albatross! Get your albatross here!"

// String 型別包含了一些特殊的字元常數，它們是：
"\0"         // 空字元
"\\"         // 反斜線
"\t"         // 製表符(Tab)
"\n"         // 換行符號
"\r"         // 歸位符號(Carriage return)
"\""         // 雙引號
"\'"         // 單引號
"\u{24}"       // 單位元組的萬國碼
"\u{2665}"     // 雙位元組的萬國碼
"\u{0001F49c}" // 四位元組的萬國碼

// 初始化一個空字串 - 這四個在等號兩邊的表達式都是等價的
var emptyString = ""
var anotherEmptyString = String()

// 使用 'isEmpty' 來檢查一個空字串
if emptyString.isEmpty
{
	"Yep, it's empty"
}

// String 型別是'值型別'，但為了效率的關係它們只有在修改的時候才會做複製的動作
func somefunc(a: String)
{
	var b = a
	b = "Changed!"
}

var originalString = "Original"
somefunc(originalString)
originalString // 並沒有修改

// 你可以使用以下這個方式去迭代一個字串：
for character in originalString
{
	character
}

// Character 跟 String 一樣使用雙引號來指定，所以你必須顯式地做型別註解來宣告一個 Character：
var notAString: Character = "t"

// String 型別並沒有 length 或 count member 這類屬性，你必須使用全域函式 count()
//
// 這很像呼叫 strlen，因為這個函式迭代了整個萬國碼的字串並細數包含的每一個字元。請留意萬國碼的字元長度不盡相同，
// 因此這不是一個直觀的處理過程。
//
// 也請留意透過 count 所計算出來的字元數目，並不總是與 NSString 所提供的 length 屬性回報的相同。
// NSString 計算字串中包含多少字元的方式，是建立使用 UTF-16 來表達字串的方式上，而不是字串中萬國碼的個數。為了反映
// 這個事實，當使用 NSString 的 length 屬性來取得 Swift 的 String 的字串長度時，它是呼叫 utf16count 這個方法
// 來計算字元的個數
count(originalString)

// 將 Character 轉為 String 後，可以使用 + 號直接連接
var helloworld = "hello, " + "world"

// ------------------------------------------------------------------------------------------------
// 字串插入
//
// 字串插入的操作方式參照了字串內部所參照到的值。當使用在印出資料的函式上時，作用的方式不同。字串插入的操作方式允許你
// 將任何值直接安插到字串中的任何位置，而不需要當作額外的參數去處理
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"

// ------------------------------------------------------------------------------------------------
// 比較字串
//
// 使用 = 來比較字串間的大小寫相不相同，甚至是兩字串間相不相等
var str1 = "We're a lot alike, you and I."
var str2 = "We're a lot alike, you and I."
str1 == str2

// 你也可以比較字串的前綴或後綴
str1.hasPrefix("We're")
str2.hasSuffix("I.")
str1.hasPrefix("I.")

