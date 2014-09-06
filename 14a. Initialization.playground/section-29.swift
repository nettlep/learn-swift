struct Point
{
	var x = 0.0
	var y = 0.0
}

struct Rect
{
	var origin = Point()
	var size = Size()
	
	// We create a basic initializer to use the default values Since we define other initializers,
	// the system won't create this for us, so we need to define it ourselves. Since we're using
	// the defaults, it is an empty closure.
	init() {}
	
	// Init from origin/size
	init(origin: Point, size: Size)
	{
		self.origin = origin
		self.size = size
	}
	
	// Init from center/size - note how we use the init(origin:size) to  perform actual
	// initialization
	init(center: Point, size: Size)
	{
		let originX = center.x - size.width / 2
		let originY = center.y - size.height / 2
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}