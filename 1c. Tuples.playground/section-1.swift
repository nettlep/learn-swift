// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 一組值可以結合成一個單一的複合類型，這個複合類型就稱之為元組
// ------------------------------------------------------------------------------------------------

// 定義一個元組 - 使用一組括弧將使用逗號分割開的一系列值包在一起
//
// 這個元組並沒有指定其中數值的類型，它靠的是類型的自動推斷
let httpError404 = (404, "Not found")

// 也能自己指定類型來避免自動推斷
let someOtherTuple = (Double(100), Bool(false))

// 將元組分解為個別常數的方式就像這樣
let (statusCode, statusMessage) = httpError404
statusCode
statusMessage

// 也能將元組分解為個別變數而不是常數，不過我想你已經試出來了
var (varStatusCode, varStatusMessage) = httpError404
varStatusCode
varStatusMessage

// 你也能使用 . 運算子加上元組中元素的索引值來存取它們
httpError404.0
httpError404.1

// 除此之外，還可以為元組中的元素命名
let namedTuple = (statusCode: 404, message: "Not found")

// 當你為元組中的元素命名後，就可以使用 . 運算子加上元組中元素的命名值或索引值來存取它們，兩種做法是完全等效的
namedTuple.statusCode == namedTuple.0
namedTuple.message == namedTuple.1

