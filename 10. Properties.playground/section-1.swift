// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 屬性儲存了類別、結構以及列舉中的值
// ------------------------------------------------------------------------------------------------

// 這兒是一個裡頭有幾個簡單屬性的結構：
struct FixedLengthRange
{
	var firstValue: Int
	let length: Int
}

// 結構必須在初始化的時候將其中的每個屬性都初始完成
//
// 以下這一行無法編譯，因為結構裡頭的屬性並未初始化完成：
//
// var anotherRangeOfThreeItems = FixedLengthRange()
//
// 為了實體化一個 FixedLengthRange 結構，我們必須使用針對個別成員的建構器。注意這個將會實體化結構中的一個常數以及
// 一個變數：
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6

// ------------------------------------------------------------------------------------------------
// 延遲儲存屬性
//
// 一個延遲儲存屬性在它被使用之前不會計算它的初始值
//
// 它們被宣告為 "lazy" 屬性，並且不能是常數
//
// 全域的常數/變數不需要特別加上 "lazy" 就會延遲計算，區域常數/變數不會延遲計算
//
// 在這兒，我們會定義一些類別來展示這個延遲儲存屬性。在這個例子中，讓我們假設 DataImporter 是個耗時的程序，正因為如
// 此，我們會想在使用這個耗時的類別的時候，加上延遲儲存屬性。如此一來，如果完全沒有使用到這個屬性，那就永遠不需要為了
// 這個耗時的初始化付出代價
class DataImporter
{
	var filename = "data.txt"
}

class DataManager
{
	lazy var importer = DataImporter()
	var data = [String]()
}

// 現在讓我們實體化這個 DataManager，然後為這個類別增加一些簡單的資料：
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")

// 注意我們還沒有使用這個有延遲儲存屬性的 importer，所以它的值還是 nil：
manager

// 現在讓我們存取這個屬性：
manager.importer.filename

// 此時這個 impoter 屬性已經被創建出來了：
manager

// ------------------------------------------------------------------------------------------------
// 計算屬性
//
// 計算屬性沒有直接儲存值，它使用 getters 以及 setter 來存取當需要的時候才被計算出來的值
//
// 在全域以及區域範圍都可以定義計算屬性的變數
//
// 我們從一些結構開始，將使用它們來展示儲存屬性是如何運作的
struct Point
{
	var x = 0.0, y = 0.0
}
struct Size
{
	var width = 0.0, height = 0.0
}

// 下列的結構包含了一個名稱為 'center' 的 Point 型別計算屬性。留意 'center' 是一個變數，而非常數。這是一個計算屬性
// 的基本要求
//
// 每一個計算屬性都必須擁有 getter 方法，但不一定需要 setter。如果提供了 setter 方法，那麼我們必須知道這個將要被賦
// 值到計算屬性的新值。這個新值的名稱為'newCenter'。注意，這個值不能使用型別註解，因為計算屬性早已知道它是 Point 型
// 別，顯式地加上型別註解將引起編譯錯誤
struct Rect
{
	var origin = Point()
	var size = Size()
	var center: Point
	{
		get
		{
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set(newCenter)
		{
			origin.x = newCenter.x - (size.width / 2)
			origin.y = newCenter.y - (size.height / 2)
		}
	}
}

// 這兒，我們將會創建一個 Rect 型別的 square 變數
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))

// 我們現在可以取用 square 中從 Rect 的原點以及大小等屬性中計算出來的 center 點。作為一個計算屬性，我們使用它的方式
// 跟其他種屬性沒有什麼不同
let initialSquareCenter = square.center

// 因為我們提供了 setter 方法，所以也可以把 center 點當作一般儲存值一樣地設值。這個動作會基於新的 center 點來更新原
// 本 Rect 結構中 origin 點的值
square.center = Point(x: 15, y: 15)

// 我們可以看看這個 origin 點的值已經從 (0, 0) 被更新到 (10, 10)：
square.origin

// Setter 方法的簡寫宣告
//
// Rect 結構中提供了一個名為 'newCenter' 的參數給計算屬性的 setter 方法。如果我們不指定這個參數，Swift 將會自動地
// 為我們產生一個名為 'newValue' 的參數
//
// 這裡 AlternativeRect 結構跟 Rect 結構的宣告幾乎一模一樣，只差在 setter 方法使用了 Swift 的默認 'newValue'
// 參數
struct AlternativeRect
{
	var origin = Point()
	var size = Size()
	var center: Point
	{
		get
		{
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set
		{
			origin.x = newValue.x - (size.width / 2)
			origin.y = newValue.y - (size.height / 2)
		}
	}
}

// 我們也可以藉著只提供 getter 方法，來擁有一個唯讀的計算屬性
struct Cube
{
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double
	{
		get
		{
			return width * height * depth
		}
	}
}

// 除此之外，Swift 允許我們使用捨去了 get{} 區塊的簡化語法來使用唯讀的計算屬性。你只需要將計算屬性的宣告區塊直接擺在
// 變數名稱下方即可：
struct AnotherCube
{
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double
	{
		return width * height * depth
	}
}

// 讓我們宣告一個 AnotherCube 結構並且讀取其中的 'volume' 屬性
var cube = AnotherCube(width: 4, height: 5, depth: 2)
cube.volume

// 因為 'volume' 屬性是唯讀的，如果我們試著賦值給它，將會產生一個編譯錯誤
//
// 下面這一行程式碼無法編譯：
//
// cube.volume = 8.0

// ------------------------------------------------------------------------------------------------
// 屬性監視器
//
// 屬性監視器允許我們對屬性值的改變做回應。我們可以宣告一個在屬性值將改變前觸發的屬性監視器(讓我們選擇性地改變將被更新
// 的值)，或者是屬性值已改變後的時候觸發的屬性監視器，這個屬性監視器會包含一段我們自己寫的程式碼區塊
//
// 在全域以及區域範圍都可以為變數定義屬性監視器
//
// 這些屬性監視器在屬性初始化的時候不會觸發，僅只在屬性值改變的時候才觸發
//
// 與 setter 函式相似，每一個 'willSet' 以及 'didSet' 都會接收一個代表(以 'willSet' 方法為例)即將被賦值進屬性
// 的參數以及(以 'willSet' 方法為例)這個屬性在被改變前的原始值
class StepCounter
{
	var totalSteps: Int = 0
	{
		willSet(newTotalSteps)
		{
			"About to step to \(newTotalSteps)"
		}
		didSet(oldTotalSteps)
		{
			"Just stepped from \(oldTotalSteps)"
		}
	}
}

// 讓我們創建一個 StepCounter 的實體，以試試寫好的屬性監視器
let stepCounter = StepCounter()

// 下面的表達式先會呼叫 totalSteps 屬性的 'willSet' 方法，接下來是改變 totalSteps 屬性的值，最後才是呼叫這個屬性
// 的 'didSet' 方法
stepCounter.totalSteps = 200

// 類似於 setter 方法，我們可以靠著捨棄掉 'willSet' 以及 'didSet' 方法中的參數，來簡化個別的屬性監視器。當這麼做的
// 時候，Swift 會自動地分別為這些方法提供 'newValue' 以及 'oldValue' 的參數
class StepCounterShorter
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { "Just stepped from \(oldValue)" }
	}
}

// 我們也可以在 'didSet' 屬性監視器中，藉著直接改變屬性的值來覆寫掉先前的寫入操作。如果你在 'willSet' 方法中修改屬性
// ，將會得到一個編譯警告
//
// 讓我們試著將 totalSteps 這個屬性的範圍限制在 0...255
class StepCounterShorterWithModify
{
	var totalSteps: Int = 0
	{
		willSet{ "About to step to \(newValue)" }
		didSet { totalSteps = totalSteps & 0xff }
	}
}
var stepper = StepCounterShorterWithModify()
stepper.totalSteps = 345
stepper.totalSteps // 這一行回傳 totalSteps 的值已設置為 89

// ------------------------------------------------------------------------------------------------
// 型別屬性
//
// 到現在為止，我們使用的實體屬性以及實體方法，都是類別、結構或列舉的實體。每一個實體都有它們自己獨立的屬性或方法
//
// 型別屬性是附屬在類別上的屬性，結構或列舉本身並不屬於任何一個特定的實體。所有擁有相同型別的實體都會共享同一份型別屬性
//
// 對於值型別而言(結構和列舉)，使用 'static' 關鍵字來定義型別屬性，對於參考型別而言(類別)，使用 'class' 關鍵字來定
// 義型別屬性
//
// 這相似於類 C 語言中的 'static' 變數
//
// 對於值型別而言(結構和列舉)，可以定義儲存屬性和計算型別屬性，對於一般的儲存屬性或計算屬性來說，除了儲存屬性總是必須有
// 初始值以外，所有的規則都是一樣的。為什麼有這個例外的原因，在於每個實體都有屬於自己的獨立建構器(以後會談)，正因為如此
// ，無法用來初始化型別屬性
//
// 這兒是一個擁有幾個型別屬性的結構
struct SomeStructure
{
	static var storedTypeProperty = "some value"
	
    // 這裡有一個使用了語法簡寫的唯讀計算屬性
	static var computedTypeProperty: Int { return 4 }
}

// 同樣的，這裡是一個擁有幾個型別屬性的列舉
enum SomeEnum
{
	static let storedTypeProperty = "some value"
	
	static var computedTypeProperty: Int { return 4 }
}

// 類別有一點不同的地方，在於它們無法定義儲存型別屬性，但是可以定義計算型別屬性
class SomeClass
{
    // 下面這一行無法編譯，因為類別不允許儲存型別屬性
	//
	// class var storedTypeProperty = "some value"
	
    // 這是唯讀的，但你也可以定義可讀寫的計算型別屬性
	class var computedTypeProperty: Int { return 4 }
}
