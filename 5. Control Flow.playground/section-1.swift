// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 許多 Swift 中控制流程的語法跟類 C 語言相似，但有些關鍵的不同。例如，switch-case 結構具有更大的彈性與強大
//   的功能，以及功能被延伸的，能跳轉到其他程式碼的 break 與 continue
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// For 循環
//
// 我們能夠使用封閉的範圍運算子 ("...") 來循環一個範圍
//
// 在下面的循環中，'index' 是個會自動宣告的常數：
for index in 1...5
{
	"This will print 5 times"
	
    // 身為一個常數，使得下面的這一行程式碼無法編譯：
	//
	// index = 99
}

// 在先前循環中自動宣告的 'index' 常數，其作用範圍只有那個循環，其結果就是你不能在循環以外的地方存取它。
// 下面這一行是不能編譯的：
//
// index = 0

// 我們可以使用半封閉的範圍運算子 ("..<") 來循環一個範圍：
//
// 我們也能重複使用 'index' 當變數名稱，原因是先前提過的作用範圍
for index in 1 ..< 5
{
	"This will print 4 times"
}

// 下面的陳述是來自蘋果電腦的 "Swift 程式語言" 書籍，但我發現這個說法跟實際運作的結果不太相同：
//
// "index 常數的作用範圍只存在於循環當中。如果你想在循環結束後檢查 index 的值，或者將這個 index 當作變數
// 而非常數來使用，你必須在開始循環前就宣告它。"
//
// 實際運作的狀況是，這個循環的常數會覆寫掉所有的區域變數/常數而且讓它的作用範圍只存在於循環裡頭，
// 在循環結束後就消失：
var indx = 3999
for indx in 1...5
{
	indx // 這個範圍包含 1 到 5

	// 'indx' 的行為還是常數，所以下面這一行無法編譯
	//
	// indx++
}

// 在循環結束後，'indx' 裡頭儲存的仍然是原先 3999 的值
indx

// 如果不需要使用循環索引常數，我們可以使用下劃線來代替循環的索引
for _ in 1...10
{
	println("do something")
}

// 我們可以使用 for-in 迭代陣列
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names
{
	name
}

// 我們可以使用 for-in 迭代字典的鍵/值對
let numberOfLegs = ["Spider":8, "Ant":6, "Cat":4]
for (animalName, legs) in numberOfLegs
{
	animalName
	legs
}

// 我們可以使用 for-in 迭代字串中的字元
for character in "Hello"
{
	character
}

// 我們能夠使用 For-條件遞增 的循環結構，跟所有類 C 語言的操作方式一樣
//
// 留意這個循環索引值是變數，不是常數。事實上，因為要遞增(++index)的關係，它們不可以是常數
for (var index = 0; index < 3; ++index)
{
	index
}

// 在 For-條件遞增結構兩邊的括號是可用可不用的
for var index = 0; index < 3; ++index
{
	index
}

// 變數的作用範圍限制在 For-條件遞增的結構中。預先宣告變數可以改變這個行為
var index = 3000
for index = 0; index < 3; ++index
{
	index
}
index // 在循環結束後，index 中的值為 3

// ------------------------------------------------------------------------------------------------
// While 循環
//
// While 循環像其他的類 C 語言。它們在執行每一次的迭代前會檢查條件成不成立：
while index > 0
{
	--index
}

// Do-While 循環也像其他的類 C 語言的同行。它們執行每一次的迭代後會檢查條件成不成立。其結果就是在循環中
// 的程式碼至少會執行一次：
do
{
	++index
} while (index < 3)

// ------------------------------------------------------------------------------------------------
// 條件語句
//
// if 條件除了兩邊的括號是可用可不用的，其餘都很像其他類 C 語言。你也可以使用 'else' 以及 'else if'
// 將多個條件判斷綁在一起：
if (index > 0)
{
	"Index is positive"
}
else if index == 0
{
	"index is zero"
}
else
{
	"index is negative"
}

// switch 陳述語句的功能要比其他類 C 語言強大多了。我們從這裡列出的幾個不同之處來開始：
//
// 不像其他類 C 語言，switch 陳述並不需要 "break" 來避免流程往下一個 case 執行
//
// 另外，可以藉由在一個 case 中使用逗號分隔多個條件來滿足多重條件的需求
//
// switch 結構必須窮舉所有可能的情況，否則編譯器將產生一個錯誤
//
// 還有許多的不同之處，但讓我們從這個簡單的 switch 陳述開始：
let someCharacter: Character = "e"
switch someCharacter
{
	case "a", "e", "i", "o", "u":
		"a vowel"
	
	case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "u", "z":
		"a consonant"

    // default 條件是必要的，因為 switch 結構必須窮舉所有可能的情況，以此例子來說就是捕捉所有其他的字元
	default:
		"not a vowel or consonant"
}

// 每一個 case 區塊中至少都要有一行表達式，註解不算
//
// 否則你會得到一個無法編譯的回應。下面這段程式碼無法編譯，因為有一個空的 case "a" 區塊：
//
// let anotherCharacter: Character = "a"
// switch anotherCharacter
// {
//		case "a":
//		case "A":
//			"the letter a"
//		default:
//			"not the letter a"
//	}

// 我們可以使用範圍運算子來匹配 case 的條件：
let count = 3_000_000_000_000
switch count
{
	case 0:
		"no"
	case 1...3:
		"a few"
	case 4...9:
		"several"
	case 10...99:
		"tens of"
	case 100...999:
		"hundreds of"
	case 1000...999999:
		"thousands of"
	default:
		"millions and millions of"
}

// 使用元組來匹配條件：
//
// 為了匹配這些元組，我們也能在元組中使用範圍運算子，甚至是藉由下劃線 ("_") 來無視元組中特定的值來匹配
// 部份的元組：
let somePoint = (1,1)
switch somePoint
{
	case (0,0):
		"origin"
	
    // 只有 y=0 的時候才匹配
	case (_, 0):
		"On the X axis"
	
    // 只有 x=0 的時候才匹配
	case (0, _):
		"On the y axis"
	
    // 當 x 與 y 的範圍在 -2...2 之間的時候才匹配
	case (-2...2, -2...2):
		"On or inside the 2x2 box"
	
    // 其他條件
	default:
		"Outisde the 2x2 box"
}

// 在 switch 陳述語句中使用值綁定
//
var anotherPoint = (2, 8)
switch anotherPoint
{
    // 當 y=0 的時候，綁定元組的第一個值到 'x' (匹配所有的 x)
	case (let x, 0):
		"On the x axis with an x value of \(x)"
	
    // 當 x=0 的時候，綁定元組的第二個值到 'y' (匹配所有的 y)
	case (0, let y):
		"On the y axis with an y value of \(y)"
	
    // 當匹配任意 x 與 y 的時候，綁定元組中的所有值。留意放在括號外面的 'let' 簡化表達式，這裡也可以
    // 使用 'var'
	//
    // 也留意當匹配任意 x 與 y 的時候，我們滿足了在 switch 語句中必須窮舉所有可能的情況的規定
	case let (x, y):
		"Somewhere else on \(x), \(y)"
}

// 我們也能在 case 語句中混用 let/var。下面的這段程式碼除了最後的 case 外，跟先前的程式碼完全相同，
// 它混用了變數與常數去綁定元組中的 x 與 y
switch anotherPoint
{
	case (let x, 0):
		"On the x axis with an x value of \(x)"
	
	case (0, let y):
		"On the y axis with an y value of \(y)"
	
	case (var x, let y):
		++x // 可以修改變數 x，不能修改常數 y
		"Somewhere else on \(x), \(y)"
}

// case 後面的 where 語句允許我們使用更詳細的條件來匹配。where 語句可以使用在同一行 case 中宣告
// 的變數或常數：
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint
{
	case let (x, y) where x == y:
		"On the line of x == y"
	
	case let (x, y) where x == -y:
		"On the line of x == -y"
	
	case let (x, y):
		"Just some arbitrary point"
}

// ------------------------------------------------------------------------------------------------
// 控制移轉語句
//
// Swift 支援在 switch-case 結構中使用進階的 continue、break 以及新增的 'fallthrough' 語句
//
// 因為 Swift 不需要 break 語句來避免執行下一個 case，我們依然可以使用它來提前跳出目前的 case。
// 在 break 後方的第一個陳述句將成為緊接著整個 switch 結構的下一個語句
let someValue = 9000
switch someValue
{
	case let x where (x & 1) == 1:
		if someValue < 100
		{
			"Odd number less than 100"
			break
		}
		"Odd number greater or equal to 100"
		
	case let x where (x & 1) == 0:
		if someValue < 100
		{
			"Even number less than 100"
			break
		}
		"Even number greater or equal to 100"
	
	default:
		"Unknown value"
}

// 因為每個 case 都必須有個陳述句，而且我們必須窮舉所有可能的情況，所以可以透過 break 陳述句來有效地停止
// 這個 case 陳述句：
switch someValue
{
	case Int.min...100:
		"Small number"
	
	case 101...1000:
		break // 我們不在乎位在中間範圍的數字
	
	case 1001...100_00:
		"Big number"
	
	default:
		break // 我們不在乎剩下的數字
}

// 因為我們不需要使用 break 來避免執行下一個 case，所以當我們打算繼續執行下一個 case 的時候，必須使用
// 'fallthrough' 關鍵字來達成
let integerToDescribe = 5
var integerDescription = "\(integerToDescribe) is"
switch integerToDescribe
{
	case 2, 3, 5, 7, 11, 13, 17, 19:
		integerDescription += " a prime number, and also"
		fallthrough
	
	default:
		integerDescription += " an integer."
}

// 在 Swift 中的 continue 與 break 陳述句，其功能已被擴展為可以指定要 continue 或 break 哪一個
// switch 或循環
//
// 使用標籤來啟用這個功能，方式就類似 C 語言中的 goto 陳述句
//
// 下面的程式碼會將符合條件"碰到字元 'a' 的時候，跳到下一個名字"的所有名字都印出來
var result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "a":
                // break 跳出 theSwitch 與 characterLoop
				break characterLoop
			
			default:
				result += String(character)
		}
	}
}
result

// 同樣的，這段程式碼會印出不包括字元 'a' 的所有名字
result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "a":
                // continue 執行後直接回到 characterLoop，跳過 name 變數中的這個字元
				continue characterLoop
			
			default:
				result += String(character)
		}
	}
}
result

// 同樣的，這段程式碼在找到 'x' 字元之前會將所有名字印出來，找到後就跳出整個流程
result = ""
nameLoop: for name in names
{
	characterLoop: for character in name
	{
		theSwitch: switch character
		{
			case "x":
                // break 跳出了整個 nameLoop 的循環
				break nameLoop
			
			default:
				result += String(character)
		}
	}
}
result
