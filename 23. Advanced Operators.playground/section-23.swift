let Epsilon = 0.1e-7

func == (left: Vector2D, right: Vector2D) -> Bool
{
	if abs(left.x - right.x) > Epsilon { return false }
	if abs(left.y - right.y) > Epsilon { return false }
	return true
}
func != (left: Vector2D, right: Vector2D) -> Bool
{
	// Here, we'll use the inverted result of the "==" operator:
	return !(left == right)
}