// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * Swift 中的列舉(enumeration)與其他的類 C 語言們不太一樣。在絕大多數的類 C 語言裡頭，列舉儲存了"一組整數值"
//   。而 Swift 裡的列舉可被視為儲存一組具有自訂名稱的型別
//
//   澄清一下：與其保存該整數型預定義的值，(Error = -1, Success = 0)，Swift 中的列舉只關聯了一個具有自訂名稱的
//   型別(如整數、字串、元組等等)。還可以將"相關值"賦值給這些列舉的成員，舉例來說，一個叫做 Error 的列舉值，可以儲
//   存一個裡頭包含了一個整數型別的錯誤碼，以及一個字串型別的元組。每一次當函式或一段程式碼賦值或回傳這個具有相關值
//   的列舉 Error(Int, String) 時，它都可以使用不同的 Int/String 來填滿這個元組以代表特定的錯誤狀態
//
// * 不僅只是儲存具有自訂名稱的型別，也可以將 Swift 中的列舉指定為特定的型別。如果這個型別是 Int，那麼這個列舉的行
//   為就會比較像其他類 C 語言中的列舉
// ------------------------------------------------------------------------------------------------

// 這兒的例子是一個單純的列舉
//
// 不像其他類 C 語言，列舉中的成員型別並不是整數型(0, 1, 2 等等)。取而代之的是每一個列舉中的成員，都是一個完整而獨
// 立的值，它們都具有自定義的型別名稱 Planet
enum Planet
{
	case Mercury
	case Venus
	case Earth
	case Mars
	case Jupiter
	case Saturn
	case Uranus
	case Neptune
}

// 你也可以將多個成員放在同一行，或乾脆全放在一起。這對列舉本身不會造成任何影響
enum CompassPoint
{
	case North, South
	case East, West
}

// 讓我們將一個列舉儲存到變數中。可以讓編譯器自動推斷這個變數的型別：
var directionToHead = CompassPoint.West

// 現在 directionToHead 這個變數的型別是 CompassPoint (靠自動推斷而得)。我們可以使用這個簡化的語法，使用其他的
// CompassPoint 內容值來為這個變數賦值：
directionToHead = .East

// 我們可以使用 switch 來匹配列舉中的值
//
// switch 結構必須窮舉所有可能的情況。在這個例子中，Swift 的編譯器曉得這個型別為 CompassType 的列舉只有 4 種可能
// 的情況，因此只要這 4 種情況都被包含了，我們就不需要使用 default case
switch directionToHead
{
	case .North:
		"North"
	case .South:
		"South"
	case .East:
		"East"
	case .West:
		"West"
}

// ------------------------------------------------------------------------------------------------
// 相關值
//
// 我們可以在 switch-case 中，使用元組來取得列舉成員內含的相關值
//
// 下面這個型別為 Barcode 的列舉，不只儲存了一個條碼的型別(UPCA, QR Code)，也儲存了條碼的內容(這對大多數人應該
// 是一個陌生的概念)
enum Barcode
{
	case UPCA(Int, Int, Int) // 擁有 3 個 Int 型別相關值的 UPCA
	case QRCode(String)      // 擁有 1 個 String 型別相關值的 QRCode
}

// 讓我們宣告一個變數為 UPCA (讓編譯器自動推斷列舉是 Barcode 型別)
var productBarcode = Barcode.UPCA(0, 8590951226, 3)

// 讓我們將這個變數更改為 QRCode (仍然是 Barcode 型別)
productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

// 我們使用 switch 語句來檢查這個變數的值，並且從變數中取出列舉成員的相關值：
switch productBarcode
{
	case .UPCA(let numberSystem, let identifier, let check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	case .QRCode(let productCode):
		"QR: \(productCode)"
}

// 使用簡化的 switch 語句(請看控制流程章節)來減少 'let' 關鍵字的使用次數：
switch productBarcode
{
    // 所有常數
	case let .UPCA(numberSystem, identifier, check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	
    // 所有變數
	case var .QRCode(productCode):
		"QR: \(productCode)"
}

// ------------------------------------------------------------------------------------------------
// 原始值
//
// 我們可以指定列舉的型別。如果我們使用 Int 當作列舉的型別，那麼這個列舉的行為將會跟其他類 C 語言的列舉一樣：
enum StatusCode: Int
{
	case Error = -1
	case Success = 9
	case OtherResult = 1
	case YetAnotherResult // 未指定值的列舉成員，其值會自動從上一個列舉成員的值加 1
}

// 我們可以透過 rawValue 這個成員屬性來取得列舉成員的原始值：
StatusCode.OtherResult.rawValue

// 我們可以指定不同的型別給列舉，這兒是一個指定為 Character 型別的列舉：
enum ASCIIControlCharacter: Character
{
	case Tab = "\t"
	case LineFeed = "\n"
	case CarriageReturn = "\r"
	
    // 請注意只有 Int 型別的列舉成員值會自動增加。因為這個列舉的型別是 Character，所以下一行無法編譯：
	//
	// case VerticalTab
}

// 另外，我們也可以指定列舉為 String 型別：
enum FamilyPet: String
{
	case Cat = "Cat"
	case Dog = "Dog"
	case Ferret = "Ferret"
}

// 而且我們也可以取得它們的原始值：
FamilyPet.Ferret.rawValue

// 我們也可以透過原始值來產生列舉值。請留意回傳的結果是一個可選型別，因為無法保證傳入的原始值一定有相應的列舉值：
var pet = FamilyPet(rawValue: "Ferret")

// 讓我們檢查一下：
if pet != .None { "We have a pet!" }
else { "No pet :(" }

// 另一個例子，當傳入的原始值沒有相應的列舉值時，將會得到一個內容物為 nil 的可選型別：
pet = FamilyPet(rawValue: "Snake")
if pet != .None { "We have a pet" }
else { "No pet :(" }

