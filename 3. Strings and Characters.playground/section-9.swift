func somefunc(a: String)
{
	var b = a
	b = "Changed!"
}

var originalString = "Original"
somefunc(originalString)
originalString // not modified