struct Cube
{
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double
	{
		get
		{
			return width * height * depth
		}
	}
}