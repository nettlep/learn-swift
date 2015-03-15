// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 方法(method)就是關聯到實體的函式，適用於類別、結構、列舉以及型別方法，它就像類 C 語言中的靜態(static)方法
// ------------------------------------------------------------------------------------------------

// 實體方法
//
// 實體方法使用在類別、結構或者是列舉的實體上。為了呼叫一個實體方法，你必須先實體化一個類別、結構或者是列舉然後再透
// 過這個實體來呼叫這些方法
//
// 這兒，我們創建一個擁有單一個實體方法的類別
class SomeClass
{
	func doSomething()
	{
		// ...
	}
}

// 因為這應該很清楚了，讓我們快轉到方法的內部以及外部參數名稱
//
// 方法的外部參數名稱，跟函式的外部參數名稱默認的運作方式不太相同
//
// 以方法而言，默認的行為是呼叫方法的時候，除了方法的第一個參數外，必須總是指定所有傳入參數的參數外部名稱。設計方法
// 的人不需要為這些傳入參數指定外部參數名稱，因為方法的參數被視為擁有默認的 '#' 符號，從而創建了一個能夠反映內部參
// 數名稱的外部參數名稱
//
// 為了覆寫這個"方法的第二個及後續的參數擁有默認的外部參數名稱“行為，你可以在第一個參數以外的所有參數前方指定 "_"
// 符號
//
// 如果你想要呼叫方法的人也在第一個參數前方使用外部參數名稱，請確定在第一個參數名稱的前面加上 '#' 符號，或者直接顯
// 式地加上自定義的外部參數名稱
//
// 這兒的類別，演示了多種內部參數以及外部參數的不同組合：
class Counter
{
	var count = 0;
	
    // 沒有任何參數
	func increment()
	{
		count++
	}
	
    // 一個參數。不需要外部參數名稱
	func incrementBy(amount: Int)
	{
		count += amount
	}
	
    // 一個參數。覆寫默認的行為，需要呼叫此方法的人在第一個(也只有一個)參數使用外部參數名稱
	func addValueTo(value amount: Int)
	{
		count += amount
	}
	
    // 兩個參數。因為沒有顯式地指定外部參數名稱，會使用默認的行為：呼叫此方法的人不需要指定第一個參數的外部參數名稱
    // ，但必須指定其餘參數的外部參數名稱：
	func addTwiceWithExternalImplied(first: Int, second: Int)
	{
		count += first
		count += second
	}
	
    // 兩個參數。在所有的參數上顯式地使用外部參數名稱，強制呼叫此方法的人在每一個參數上都得使用它們，包括第一個參數
	func addTwiceWithExternalSpecified(a first: Int, b second: Int)
	{
		count += first
		count += second
	}
	
    // 兩個參數。使用外部參數名稱的簡寫 '#'，強制呼叫此方法的人在第一個參數上也要使用外部參數名稱，其餘參數的內部/
    // 外部參數名稱是相同的
	func addTwiceWithExternalSpecified2(#first: Int, second: Int)
	{
		count += first
		count += second
	}
	
    // 兩個參數。使用 '_' 讓所有參數都不需使用外部參數名稱
	func addTwiceWithExternalSpecified3(first: Int, _ second: Int)
	{
		count += first
		count += second
	}
}

// 現在讓我們看看如何呼叫這些個別的方法
var counter = Counter()
counter.increment()
counter.incrementBy(4)
counter.addValueTo(value: 4)
counter.addTwiceWithExternalImplied(50, second: 4)
counter.addTwiceWithExternalSpecified(a: 50, b: 4)
counter.addTwiceWithExternalSpecified2(first: 10, second: 10)
counter.addTwiceWithExternalSpecified3(10, 10)
counter.count

// 'self' 屬性指向類別、結構或是列舉本身。C++ 的開發者可以將 'self' 視為 'this'
class Point
{
	var x: Int = 10
	
	func setX(x: Int)
	{
        // 使用 self 來指定現在呼叫的 x 屬於 Point 類別的屬性，消除同名變數造成的歧義
		self.x = x
	}
}

// ------------------------------------------------------------------------------------------------
// 變異
//
// 結構以及列舉的實體方法不能修改它們的屬性。想這麼做的話必須在實體方法的前面加上 'mutating' 關鍵字
struct Point2
{
	var x: Int = 10

    // 注意，前面必須使用 'mutating' 關鍵字
	mutating func setX(x: Int)
	{
		self.x = x
	}
}

// 創建一個 Point2 常數...
let fixedPoint = Point2(x: 3)

// 因為 'fixedPoint' 是個常數，所以呼叫變異方法是不被允許的：
//
// 下面這一行無法編譯：
//
// fixedPoint.setX(4)

// 如果你正在操作結構或列舉(不是類別)，你可以使用 'self' 來直接賦值
struct Point3
{
	var x = 0
	
    // 不能在類別中這麼做
	mutating func replaceMe(newX: Int)
	{
		self = Point3(x: 3)
	}
}

// 在列舉中可以把 self 賦值為同列舉中的不同成員
enum TriStateSwitch
{
	case Off, Low, High
	mutating func next()
	{
		switch self
		{
		case Off:
			self = Low
		case Low:
			self = High
		case High:
			self = Off
		}
	}
}

// ------------------------------------------------------------------------------------------------
// 型別方法
//
// 型別方法就像 C++ 中的靜態(static)方法
//
// 它們只能存取型別成員(加上了 static 關鍵字的變數)
struct LevelTracker
{
	var currentLevel = 1
	static var highestUnlockedLevel = 1
	
	static func unlockedLevel(level: Int)
	{
		if level > highestUnlockedLevel
		{
			highestUnlockedLevel = level
		}
	}
	static func levelIsUnlocked(level: Int) -> Bool
	{
		return level <= highestUnlockedLevel
	}
	mutating func advanceToLevel(level: Int) -> Bool
	{
		if LevelTracker.levelIsUnlocked(level)
		{
			currentLevel = level
			return true
		}
		else
		{
			return false
		}
	}
}

// 呼叫型別方法的方法為：直接使用型別名稱，而非實體名稱
LevelTracker.levelIsUnlocked(3)

// 如果我們試著使用實體去呼叫一個型別方法，會引起一個編譯錯誤
var levelTracker = LevelTracker()

// 下面這一行無法編譯：
//
// levelTracker.levelIsUnlocked(3)

// 以類別而言，型別方法使用 'class' 關鍵字，而不是 'static' 關鍵字：
class SomeOtherClass
{
	class func isGreaterThan100(value: Int) -> Bool
	{
		return value > 100
	}
}

// 跟結構與列舉一樣，使用型別名稱來呼叫類別中的型別方法
SomeOtherClass.isGreaterThan100(105)
