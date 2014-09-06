prefix func ++ (inout vector: Vector2D) -> Vector2D
{
	vector = vector + Vector2D(x: 1.0, y: 1.0)
	return vector
}

postfix func ++ (inout vector: Vector2D) -> Vector2D
{
	var previous = vector;
	vector = vector + Vector2D(x: 1.0, y: 1.0)
	return previous
}