struct CheckerBoard
{
	let boardColors: [Bool] =
	{
		var temporaryBoard = [Bool]()
		var isBlack = false
		for i in 1...10
		{
			for j in 1...10
			{
				temporaryBoard.append(isBlack)
				isBlack = !isBlack
			}
			
			isBlack = !isBlack
		}
		
		// Return the temporary in order to set 'boardColors'
		return temporaryBoard
	}()
	
	func squareIsBlackAtRow(row: Int, column: Int) -> Bool
	{
		return boardColors[(row * 10) + column]
	}
}