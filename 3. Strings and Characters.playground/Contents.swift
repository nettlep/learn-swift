/*:
 ## Strings and Characters
  
 * All Strings are Unicode compliant

 Here's a string
*/
var str: String = "Albatross! Get your albatross here!"
/*:
 Strings have some special character constants. They are:
*/
"\0"           // Null character
"\\"           // Backslash
"\t"           // Tab
"\n"           // Newline
"\r"           // Carriage return
"\""           // Double quote
"\'"           // Single quote
"\u{24}"       // Single-byte Unicode
"\u{2665}"     // Double-byte unicode
"\u{0001F49c}" // Four-byte unicode
/*:
 Initializing an empty string - these are equivalent to each other
*/
var emptyString = ""
var anotherEmptyString = String()
/*:
 Use 'isEmpty' to check for empty String
*/
if emptyString.isEmpty {
	"Yep, it's empty"
}
/*:
 Strings are VALUE TYPES, but they're referenced for performance so they are only copied on
 modification.
*/
func somefunc(a: String) {
	var b = a
    b
	b = "Changed!"
}

var originalString = "Original"
somefunc(a: originalString)
originalString // not modified
/*:
 You can iterate over a string like this:
*/
for character in originalString {
	character
}
/*:
 Characters use double-quotes to specify them, just like Strings, so you must be explicit if you want 
 a Character instead of a String composed of a single character.
*/
var notAString: Character = "t"
/*:
 Use String.count to get number of characters in a string
*/
originalString.count
/*:
 Strings can be concatenated with strings and characters
*/
var helloworld = "hello, " + "world"
/*:
 ### String interpolation

 String interpolation refers to referencing values inside of a String. This works different from
 printf-style functions, in that String interpolation allows you to insert the values directly
 in-line with the string, rather than as additional parameters to a formatting function.
*/
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
/*:
 ### String comparison

 String comparison is case-sensitive and can be compared for equality
*/
var str1 = "We're a lot alike, you and I."
var str2 = "We're a lot alike, you and I."
str1 == str2
/*:
 You can also compare prefix and suffix equality:
*/
str1.hasPrefix("We're")
str2.hasSuffix("I.")
str1.hasPrefix("I.")

