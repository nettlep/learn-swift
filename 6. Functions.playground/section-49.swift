func padString(var str: String, pad: Character, count: Int) -> String
{
	str = Array(count: count, repeatedValue: pad) + str
	return str
}

var paddedString = "padded with dots"
padString(paddedString, ".", 10)