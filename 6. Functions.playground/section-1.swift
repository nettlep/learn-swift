// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 像大部分的其他語言一樣，函式(function)包含了執行特定任務的程式碼，但 Swift 的函式也包含了自己才有的特點
//
// * 函式在 Swift 中也是一個型別。這表示函式可以接受其他函式作為一個參數傳入，或是將函式當作一個回傳值傳出。你
//   甚至可以宣告變數來代表函式
//
// * 函式可以是巢狀結構的，而且內部函式可以被外部函式當作回傳值傳出去。為了滿足這個操作方法，在內部函式的區域變
//   數的狀態會被"紀錄"起來。任何時候呼叫內部函式的時候，都會使用變數被記錄起來的狀態。即使是巢狀結構的函式被母
//   函式回傳的時候，行為也無二致。
// ------------------------------------------------------------------------------------------------

// 這裡是一個簡單的函式，它接受一個 String 型別的變數，回傳一個 String 型別的變數
//
// 留意每一個傳入的變數都有一個局部名稱(為了在函式裡頭使用)以及一個型別註解。回傳值的型別放在函式的結尾處，緊接著
// "->" 符號
func sayHello(personName: String) -> String
{
	return "Hello, \(personName)"
}

// 假使我們呼叫這個函式，將會收到一個問候
sayHello("Peter Parker")

// 使用逗號來分隔多重的輸入參數
func halfOpenRangeLength(start: Int, end: Int) -> Int
{
	return end - start
}

// 一個不需要傳入參數的函式，只要使用一組括號加在函式名稱後方即可：
func sayHelloWorld() -> String
{
	return "Hello, world"
}

// 一個沒有回傳值的函式可以用兩種方式來表示。第一個是使用一對空括號取代回傳的型別，也就是視為回傳一個空的元組
func sayGoodbye(name: String) -> ()
{
	"Goodbye, \(name)"
}

// 也能全部移除回傳的型別(以及 -> 分隔符號)：
func sayGoodbyeToMyLittleFriend(name: String)
{
	"Goodbye, \(name)"
}

// 函式可以回傳一個元組，讓它們一次回傳多個值
//
// 下面的這個函式只不過回傳了兩個寫死的字串
func getApplicationNameAndVersion() -> (String, String)
{
	return ("Modaferator", "v1.0")
}

// 因為回傳值的型別是元組，我們可以使用元組的命名功能來替回傳值命名：
func getApplicationInfo() -> (name: String, version: String)
{
	return ("Modaferator", "v1.0")
}
var appInfo = getApplicationInfo()
appInfo.name
appInfo.version

// ------------------------------------------------------------------------------------------------
// 外部參數名稱
//
// 我們能使用類似 Objective-C 的外部參數名稱，所以呼叫這個函式的時候，參數前面必須加上這個名稱。一個外部參數
// 名稱出現在函式局部名稱的前面
func addSeventeen(toNumber value: Int) -> Int
{
	return value + 17
}
addSeventeen(toNumber: 42)

// 如果參數的內部與外部名稱是相同的，你可以使用一個簡短的 #變數名稱 語法來一次創建這兩種名稱
//
// 下面的宣告方式不但創建了一個名為 "action" 的內部參數，也順道創建了一個名為 "action" 的外部參數：
func kangaroosCan(#action: String) -> String
{
	return "A Kangaroo can \(action)"
}

// 我們現在可以使用外部參數名稱 ("action") 來呼叫函式：
kangaroosCan(action: "jump")
kangaroosCan(action: "carry children in their pouches")

// 我們也可以使用默認的參數值。默認的參數值必須放在參數列表的尾部
//
// 在這個 addMul 的例子裡，我們將兩個數相加後，再乘上一個可選的乘數。這個可選的乘數默認值為 1，所以當這個參數
// 沒有指定的時候，乘法的動作不會影響結果
func addMul(firstAdder: Int, secondAdder: Int, multiplier: Int = 1) -> Int
{
	return (firstAdder + secondAdder) * multiplier
}

// 我們可以只使用兩個參數來呼叫這個函式
addMul(1, 2)

// 默認的參數值以及外部名稱
//
// Swift 會自動幫有默認值的參數創建外部名稱。因為在我們宣告的 addMul 中沒有指定外部名稱(要不是顯式地加上外部
// 名稱不然就是使用 # 的簡短表達式)。Swift 會以內部參數名稱為參考創建外部參數名稱。這個行為就像我們在第三個參
// 數上使用了 # 的簡短表達式
//
// 因此，當呼叫這個函式並指定值給有默認值的的參數時，我們必須在參數的前方提供它的外部名稱：
addMul(1, 2, multiplier: 9)

// 我們用下面的方式，透過指定有默認值參數的外部名稱為 "_" 來選擇不使用外部名稱：
func anotherAddMul(firstAdder: Int, secondAdder: Int, _ multiplier: Int = 1) -> Int
{
	return (firstAdder + secondAdder) * multiplier
}

// 在這兒，我們跟先前一樣不使用第三個參數來呼叫這個函式：
anotherAddMul(1, 2)

// 而現在我們可以使用三個參數來呼叫這個函式而無需加上外部名稱：
anotherAddMul(1, 2, 9)

// ------------------------------------------------------------------------------------------------
// 可變參數
//
// 可變參數允許你使用同一種型別，不定個數(零個或以上)的參數來當函式的傳入值
//
// 可變參數是以指定型別陣列的型態出現在被使用的函式中
//
// 一個函式只能擁有一個可變參數，而且它必須是函式接收列表中的最後一個參數
func arithmeticMean(numbers: Double...) -> Double
{
	var total = 0.0
	
    // 這個名為 numbers 的可變參數，對函式內部而言就像是一個陣列，所以我們可以使用 for-in 的語法去循環迭代它
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}

// 讓我們使用不同個數的參數來呼叫看看。需留意之處在於我們也能不使用任何參數，因為這個符合使用可變參數的條件
// (零個或以上)
arithmeticMean()
arithmeticMean(1)
arithmeticMean(1, 2)
arithmeticMean(1, 2, 3)
arithmeticMean(1, 2, 3, 4)
arithmeticMean(1, 2, 3, 4, 5)
arithmeticMean(1, 2, 3, 4, 5, 6)

// 如果我們打算同時使用可變參數以及有默認值的參數，可以依據下面這個例子中的順序來使用它，在函式參數列表中的最末處
//，倒數第二個位置擺有默認值的參數，最後一個位置擺可變參數
func anotherArithmeticMean(initialTotal: Double = 0, numbers: Double...) -> Double
{
	var total = initialTotal
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}

// 這裡，我們仍可不使用任何參數來呼叫這個函式，因為參數有默認值
anotherArithmeticMean()

// 繼續往下，我們必須給有默認值的參數指定外部名稱(因為我們並未選擇不使用它)。當然，你也能從這兒看出為何 Swift 要求替
// 有默認值的參數加上外部名稱，這會幫助我們辨認從有默認值的參數在哪一個位置結束，而可變參數從哪一個位置開始
anotherArithmeticMean(initialTotal: 1)
anotherArithmeticMean(initialTotal: 1, 2)
anotherArithmeticMean(initialTotal: 1, 2, 3)
anotherArithmeticMean(initialTotal: 1, 2, 3, 4)
anotherArithmeticMean(initialTotal: 1, 2, 3, 4, 5)
anotherArithmeticMean(initialTotal: 1, 2, 3, 4, 5, 6)

// 在呼叫有外部名稱的可變參數函式時，只需將外部名稱使用在第一個可變參數上(如果參數超過一個的話)
func yetAnotherArithmeticMean(initialTotal: Double = 0, values numbers: Double...) -> Double
{
	var total = initialTotal
	for number in numbers
	{
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}

// 在這兒我們能看到加入了外部名稱 "values" 的可變參數對函式呼叫的方式造成的改變：
yetAnotherArithmeticMean()
yetAnotherArithmeticMean(initialTotal: 1)
yetAnotherArithmeticMean(initialTotal: 1, values: 2)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4, 5)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4, 5, 6)

// ------------------------------------------------------------------------------------------------
// 常數以及變數參數
//
// 所有函式的參數默認都是常數。要讓它們可變的話，必須在參數名稱前加上 var 關鍵字：
func padString(var str: String, pad: Character, count: Int) -> String
{
	str = Array(count: count, repeatedValue: pad) + str
	return str
}

var paddedString = "padded with dots"
padString(paddedString, ".", 10)

// 留意函式內部的更動並沒有修改到從外部傳進去的 String 參數，因為傳進去的是參數的值拷貝：
paddedString

// ------------------------------------------------------------------------------------------------
// 進-出(In-Out)參數
//
//
// 進-出參數讓我們強制傳遞一個參數的位址進函式，以便在函式內部對此參數做的更動可以同步到函式結束後
//
// 注意加上了 inout 關鍵字的參數，不能是可變參數，也不能是有默認值的參數
//
// 我們能透過一個基本的 swap 函式來交換兩個傳入值的內容來練習這個關鍵字的使用：
func swap(inout a: Int, inout b: Int)
{
	let tmp = a
	a = b
	b = tmp
}

// 讓我們來呼叫 swap 函式，看看會發生什麼事
//
// 為了確保呼叫函式的人知道現在使用的參數是個 inout 參數(因此，可以修改傳進去的參數)，我們必須在傳入參數名稱的前方
// 加上一個 "&" 符號
//
// 留意這些參數被傳進函式的是它們在記憶體中的位址，因為預期參數中的內容會在函式裡頭被修改，所以不能被定義為常數
var one = 1, two = 2
swap(&one, &two)

// 然後我們可以發現 'one' 變數裡頭現在是 2，而 'two' 變數裡頭現在是 1
one
two

// ------------------------------------------------------------------------------------------------
// 函式型別
//
// 函式的型別由它們需要的傳入參數列表(參數的個數以及型別)以及回傳值的型別來決定
//
// 下列兩個函式擁有相同的型別
//
// 注意！這些函式的型別都被描述為：(Int, Int) -> Int
func add(a: Int, b: Int) -> Int {return a+b}
func mul(a: Int, b: Int) -> Int {return a*b}

// 一個不需要任何傳入參數，也沒有任何回傳值的函式，其型別為：() -> ()
func nop() -> ()
{
	return
}

// 下面這個函式型別與上面那一個函式的型別相同：() -> ()
//
// 這個函式使用了簡短的方式來描述，將回傳值全部移除了，但這個簡化的語法，並未改變定義這個函式型別的方式：
func doNothing()
{
	return
}

// 我們可以使用已知的函式型別，來做型別註解來定義一個變數/常數來代表擁有同型別的函式
let doMul: (Int, Int) -> Int = mul

// 我們現在可以透過定義出來的變數/常數來呼叫這個函式：
doMul(4, 5)

// 我們也能在將函式賦值給變數的時候，替其中的參數取名字，以及利用未命名參數("_")
//
// 這些額外的裝飾語法是有其目的的，但它不影響真正的函式型別，依然是：(Int, Int) -> Int
let doAddMul: (a: Int, b: Int, Int) -> Int = addMul

// 現在呼叫這個函式的時候，前面的兩個參數都需要外部名稱
doAddMul(a: 4, b: 2, 55)

// 我們也可以將函式型別當作參數傳入函式
//
// 在這兒，第一個參數名稱為 'doMulFunc'，型別則是是需要兩個傳入參數的 "(Int, Int) -> Int" 函式型別。
// 傳入參數中的 'a' 與 'b' 被使用在 'doMulFunc' 這個函式的傳入參數中：
func doDoMul(doMulFunc: (Int, Int) -> Int, a: Int, b: Int) -> Int
{
	return doMulFunc(a, b)
}

// 我們現在可以將這個函式(隨著一對準備被呼叫的參數)當作參數傳入另一個函式：
doDoMul(doMul, 5, 5)

// 我們也能將函式當回傳值傳出
//
// 擁有兩組箭頭符號，讓這個語法看起來有點奇怪。閱讀這個函式前，首先要了解第一個箭頭指定了回傳值的型別，
// 而第二個箭頭不過就是函式型別中代表回傳值的一部份：
func getDoMul() -> (Int, Int) -> Int
{
	return doMul
}
let newDoMul = getDoMul()
newDoMul(9, 5)

// 這是另一個更簡短的版本，它避免了額外宣告一個變數來代表這個函式：
getDoMul()(5, 5)

// 早先我們討論過，一個沒有回傳值的函式是如何使用 -> () 來表示它沒有回傳值
//
// 在這兒，我們將透過回傳一個沒有回傳值的函式來實際了解這個行為
func getNop() -> () -> ()
{
	return nop
}

// 並且我們將呼叫 nop(留意第二組括號代表我們呼叫的其實是nop()) 這個函式
getNop()()

// 我們可以巢狀地在函式中使用另一個函式
func getFive() -> Int
{
	func returnFive() -> Int
	{
		return 5
	}
	
    // 呼叫 returnFive() 並且回傳該函式執行的結果
	return returnFive()
}

// 呼叫 getFive 函式將回傳一個值為 5 的 Int 型別：
getFive()

// 你也可以回傳巢狀結構的函式：
func getReturnFive() -> () -> Int
{
	func returnFive() -> Int
	{
		return 5
	}
	return returnFive
}

// 呼叫 getReturnFive 函式將回傳一個能回傳值為 5 的 Int 型別的函式
let returnFive = getReturnFive()

// 這兒就是我們呼叫巢狀結構函式的方法：
returnFive()
