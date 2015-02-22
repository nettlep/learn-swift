// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 類型別名允許你使用不同的名稱來代表一個類型，與 C 語言中的 'typedef' 類似
// ------------------------------------------------------------------------------------------------

// 為 UInt16 建立一個叫做 "AudioSample" 的類型別名
typealias AudioSample = UInt16

// 這個表達式其實呼叫的是 UInt16.min
var maxAmplituedFound = AudioSample.min

// 也可以為自定義類型建立類型別名
struct MySimpleStruct
{
	static let a = 99
}

typealias MyAliasedName = MySimpleStruct
MyAliasedName.a

