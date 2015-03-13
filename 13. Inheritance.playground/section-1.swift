// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * Swift 的物件並沒有默認的基礎類別。所有不繼承其他類別的類別，都是基礎類別。
// ------------------------------------------------------------------------------------------------

// 讓我們從一個簡單的基礎類別開始：
class Vehicle
{
	var numberOfWheels: Int
	var maxPassengers: Int
	
	func description() -> String
	{
		return "\(numberOfWheels) wheels; up to \(maxPassengers) passengers"
	}
	
    // 必須初始化仍未擁有默認值的所有屬性
	init()
	{
		numberOfWheels = 0
		maxPassengers = 1
	}
}

// ------------------------------------------------------------------------------------------------
// 子類別
//
// 現在讓我們從 Vehicle 中創建一個子類別，這是個名稱為 Bicycle 的雙輪車輛
class Bicycle: Vehicle
{
    // 設置這個車輛的輪子數目為 2
	override init()
	{
		super.init()
		numberOfWheels = 2
	}
}

// 我們可以呼叫父類別的成員
let bicycle = Bicycle()
bicycle.description()

// 子類別可以繼續被其他類別繼承
class Tandem: Bicycle
{
    // 這個腳踏車可以承載 2 個乘客
	override init()
	{
		super.init()
		maxPassengers = 2
	}
}

// 我們創建一個包含了新的 description 方法的 Car 類別，這個 description 方法覆寫了父類別中的實體方法
class Car: Vehicle
{
    // 增加一個新屬性
	var speed: Double = 0.0
	
    // 新的建構器，裡頭會先執行 super.init()
	override init()
	{
		super.init()
		maxPassengers = 5
		numberOfWheels = 4
	}
	
    // 使用 override 關鍵字來指出我們覆寫了繼承鍊中的的同名方法。如果你沒有使用 'override' 關鍵字，但繼承鍊中
    // 有同名的方法，將會導致編譯錯誤
	override func description() -> String
	{
        // 我們增加了一些東西到 description 方法的默認實作裡頭
		return super.description() + "; " + "traveling at \(speed) mph"
	}
}

// 我們來檢查一下，是否 Car 類別的 description 方法不同於它的父類別的同名方法：
let car = Car()
car.speed = 55
car.description()

// ------------------------------------------------------------------------------------------------
// 覆寫屬性
//
// 我們可以覆寫屬性的 getter 以及 setter 方法。這可以使用在任何種類的屬性上，包括儲存屬性以及計算屬性
//
// 當我們這麼做的時候，被覆寫掉的屬性必須包含屬性的名稱以及型別
class SpeedLimitedCar: Car
{
    // 確定指出了屬性的名稱以及型別
	override var speed: Double
	{
		get
		{
			return super.speed
		}
        // 我們需要一個 setter 方法，因為父類別中的此屬性為讀/寫
		//
        // 然而如果父類別中的此屬性是唯讀的，我們就不需要 setter 方法，除非我們希望為這個屬性增加可寫入的能力
		set
		{
			super.speed = min(newValue, 40.0)
		}
	}
}

// 我們對這個類別的 getter/setter 覆寫已經發揮了作用
var speedLimitedCar = SpeedLimitedCar()
speedLimitedCar.speed = 60
speedLimitedCar.speed

// 我們也可以覆寫屬性監視器
class AutomaticCar: Car
{
	var gear = 1
	override var speed: Double
	{
        // 基於 speed 變數的值來調整 gear 變數
		didSet { gear = Int(speed / 10.0) + 1 }
	
        // 因為我們覆寫了屬性監視器，所以不被允許覆寫 getter/setter 方法
		// getter/setter.
		//
        // 下面這兩行不能編譯：
		//
		// get { return super.speed }
		// set { super.speed = newValue }
	}
}

// 我們對這個類別的屬性監視器覆寫已經發揮了作用
var automaticCar = AutomaticCar()
automaticCar.speed = 35.0
automaticCar.gear

// ------------------------------------------------------------------------------------------------
// 防止覆寫
//
// 我們可以使用 'final 關鍵字來防止子類別覆寫掉父類別特定的方法或屬性
//
// 'final' 關鍵字可以使用在 class、var、func、class func 以及 subscript 關鍵字前
//
// 這兒我們已在最外頭的 'class' 關鍵字前加上 'final'，這個動作就已經防止了整個類別被子類別覆寫，因為如此，在這
// 個類別裡頭的 'final' 關鍵字其實都不需要，加上 'final' 關鍵字是為了描述的方便。或許這些多餘的 'final' 關鍵
// 字在未來 Swift 版本更新的時候無法編譯，但目前還沒有問題：
final class AnotherAutomaticCar: Car
{
    // 不能覆寫這個變數
	final var gear = 1
	
    // 防止函式被進一步修改
	final override var speed: Double
	{
		didSet { gear = Int(speed / 10.0) + 1 }
	}
}
