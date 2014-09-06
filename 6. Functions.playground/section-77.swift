func getDoMul() -> (Int, Int) -> Int
{
	return doMul
}
let newDoMul = getDoMul()
newDoMul(9, 5)