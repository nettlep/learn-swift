// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 下標腳本(subscript)允許你可以使用下標腳本運算子 "[]" 來操作一個實體
//
// * 下標腳本可以使用在類別、結構以及列舉上
//
// * 下標腳本的宣告方式類似於屬性的 getter 以及 setter 方法
// ------------------------------------------------------------------------------------------------

// 下標腳本的宣告方式就像屬性的 getter 以及 setter 方法，而且也使用一樣的語法規則來支援唯讀以及讀寫兩種變形。它們
// 也可以使用跟 getter 以及 setter 相同的語法簡化
//
// 這兒是一個使用了下標腳本的結構，我們可從中瞭解使用下標腳本的語法
struct TimesTable
{
	let multiplier: Int
	
    // 唯讀的下標腳本使用了簡化了的 getter 語法
	subscript(index: Int) -> Int
	{
		return multiplier * index
	}

    // 覆寫了 Double 型別的下標腳本，也使用了簡化了的 getter 語法來製作唯讀屬性
	subscript(index: Double) -> Int
	{
		return multiplier * Int(index)
	}
}

// 我們現在如此使用剛創建的下標腳本
let threeTimesTable = TimesTable(multiplier: 3)
threeTimesTable[3]
threeTimesTable[4.0]

// 下標腳本接受任何型別的參數以及可變參數，但不能使用進-出參數(inout)或擁有默認值的參數
//
// 這兒有另一個複雜一點的例子：
struct Matrix
{
	let rows: Int
	let columns: Int
	var grid: [Double]
	
	init (rows: Int, columns: Int)
	{
		self.rows = rows
		self.columns = columns
		grid = Array(count: rows * columns, repeatedValue: 0.0)
	}
	
	func indexIsValidForRow(row: Int, column: Int) -> Bool
	{
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
    // 使用了 getter 與 setter 以及兩個傳入參數的下標腳本
	subscript(row: Int, column: Int) -> Double
	{
		get
		{
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return grid[row * columns + column]
		}
		set
		{
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			grid[row * columns + column] = newValue
		}
	}
}

// 創建一個標準的 4x4 方陣
var matrix = Matrix(rows: 4, columns: 4)
matrix[0,0] = 1
matrix[1,1] = 1
matrix[2,2] = 1
matrix[3,3] = 1
