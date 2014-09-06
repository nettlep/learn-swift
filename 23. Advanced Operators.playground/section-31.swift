infix operator +- { associativity left precedence 140 }
func +- (left: Vector2D, right: Vector2D) -> Vector2D
{
	return Vector2D(x: left.x + right.x, y: left.y - right.y)
}