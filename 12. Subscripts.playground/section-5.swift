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
	
	// Subscript with getter & setter as well as dual-parameter subscript
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