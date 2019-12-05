/*:

 ## Things to know

 * These playgrounds are modified versions of Paul Nettle's original which can be found
 at: [GitHub](https://github.com/nettlep/learn-swift)
 
 * Swift has been open sourced and is available on Linux as well.  All code in these
 Playgrounds should compile just fine on Linux though there is no Playground support
 there.

 * Some experience programming in a C-like langauge is expected when working through
 these playgrounds.  Java, JavaScript, C, C++, or C# should do just fine.
 
 * If you leave the Playground in 'Show Rendered Markup` mode, all of the commentary
 will remain while you can play with the code.

 ### Constants & Variables
 
 These are known as "Stored Values" in Swift

 Use the `let` keyword to define a constant
*/
 let maximumNumberOfLoginAttempts = 10
/*:
 Use the `var` keyword to define a variable

 *Tip:* only use variables when you need a stored value that changes.
 Otherwise, prefer constants. If you mark something as `var` but never change
 it, Swift will show a warning message recommending that you change it to `let`
 */
var currentLoginAttempt = 0
/*:
 Stored Values defined with `let` cannot change
 This line wouldn't compile:
``` 
 maximumNumberOfLoginAttempts = 9
```
 Stored Values defined with `var` can change:
*/
 currentLoginAttempt += 1
/*:
 You also can't redeclare a variable or constant _in the same scope_ 
 once it has been declared. These lines
 won't compile:
 ```
 let maximumNumberOfLoginAttempts = 10
 var currentLoginAttempt = "Some string which is not an Int"
 ```
 We will study the various Swift scoping rules later.
 
 You can combine them on a single line with a comma
*/
var x = 0.0, y = 0.0, z = 0.0
/*:
 ### Type Annotations

The Swift standard library provides a large collection of basic types.  The ones you may already be familiar with include: Int, Double, Float, Bool, String, Array, Dictionary.  There are variations of these (like UInt16), but those are the basic types. Note that all of these types are capitalized.  In Swift it is standard for Types to start with a capital letter, while stored values (variables) start with a lower case letter and use camelCase.
 
 There are 6 "types of types": `tuple`, `enum`, `struct`, `class`, `func` and `protocol`.  We will explain their differences in subsequent playgrounds.  For now you should note that all of the types listed immediately above are `struct`'s

Where possible, Swift will infer the types of things without you having to specify the type explicitly. Because of inference, type annotations are usually left out when writing Swift.  Occasionally, you will need to specify them when the compiler can't infer the type.

 Here's how you specify the type:
 */
var welcomeMessage: String
welcomeMessage = "Hello"
/*:
 If you define several stored values on one line separated by commas and append
 a `: Type` at the end, all of the stored values will be of that type.
 */
var red, green, blue: Double
/*:
 Constant and variable names cannot contain any mathematical symbols, arrows, private-use (or
 invalid) Unicode code points or line-and-box drawing characters. Nor can they begin with a
 number. Otherwise, it's open season for naming your variables! (yes, really!)

 Here are some oddly named, but perfectly valid, constants:
 */
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
/*:
 ### The print(_,separator:, terminator:) function
 
 You can print a value using the print function.  (We will study functions later).  Print takes a number of useful forms.  You can specify a list of Stored Values to print, just separate them all with a comma:
*/
print(π, x, y, z)
/*:
 Note that that prints the four variables values as Strings, separated by space and terminated with a line feed.

 You can also print just a single variable:
 */
var friendlyWelcome = "Hello!"
print(friendlyWelcome)
/*:
 To print the values in a list separated by something other than space, 
 you can specify the separator, in this case 3 underscores:
*/
print(π, x, y, z, separator: "___")
/*:
 You can also replace the terminating line feed, in this case with nothing:
 */
print(friendlyWelcome, terminator:"")
/*:
 To print multiple values separated by a separator and terminated by a tab
*/
print(friendlyWelcome, π, x, y, z, separator: "____", terminator: "\t")
/*:
 Since we're using Playgrounds, we'll just put the raw string on the line which is an expression
 that evaluates to itself, printing the result in the right-hand pane in the playground, like so:
*/
friendlyWelcome = "Bonjour!"
print("The current value of friendlyWelcome is: \(friendlyWelcome)")
"The current value of friendlyWelcome is: \(friendlyWelcome)"
/*:
 Note that this is how all Swift function invocations work.  Good Swift style entails
 using named parameters like `separator` and `terminator` in your function names.  In fact
 you have to use special syntax to NOT require named parameters as in the case of the list 
 variables to print in the call to `print(_, separator:, terminator:)`
 
### Variable Names

 As with most languages, you cannot give an identifier (such as a variable or constant name,
 class name, etc.) the same name as a keyword. For example, you can't define a constant named
 `let`:

 The following line of code will not compile:
```
 let let = 0
```
 However, sometimes it would be convenient to do so and Swift provides a means to enable this
 by surrounding the identifier with backticks (\`). Here's an example:
*/
let `let` = 42.0
/*
 We can now use `\`let\`` like any normal variable:
*/
x = `let`
/*:
 This works for any keyword:
*/
let `class` = "class"
let `do` = "do"
let `for` = "for"
/*:
 Additionally, it's important to know that this works on non-colliding identifier names:
*/
let `myConstant` = 123.456
/*:
 Also note that `\`myConstant\`` and `myConstant` refer to the same constant:
*/
myConstant

/*:
### Comments

 You've probably already figured this out, but anything after the "//" is a comment. There's more
 to comments, though:
*/
/* This is a comment
   that spans multiple lines */
/*:
 The multi-line comments are handy because they can nest, which allows you to safely comment out
 blocks of code, even if they have multi-line comments in them:
*/
/* 
	// Some variable
	var someVar = 10

	/* A function
     * 
     * This is a common way to comment functions, but it makes it difficult to comment out these
     * blocks.
     */
    func doSomething()
    {
		return
    }
*/
/*:
### Semicolons

 Semicolons on the end of a line are optional, but the preferred style for Swift is to not use
 them to terminate lines.
*/
var foo1 = 0
var foo2 = 0; // optional semicolon
/*:
 However, if you want to put two lines of code on one line, you'll need the semicolon to separate
 them.
 */
foo1 = 1; foo2 = 2
/*:
### Integers

 There are multiple types of integers. Signed and unsigned with sizes of 8, 16, 32 and 64 bits.
 Here are a couple samples:
*/
let meaningOfLife: UInt8 = 42 // Unsigned 8-bit integer
let randomNumber: Int32 = -34 // Signed 32-bit integer
/*:
 There is also Int and UInt, the defaults. These will default to the size of the current
 platform's native word size. On 32-bit platforms, Int will be equivalent to Int32/UInt32. On
 64-bit platforms it is equivalent to Int64/UInt64.

 Similarly, there is Int16/UInt16

 *Tip:* For code interoperability, prefer Int over its counterparts.
*/
let tirePressurePSI = 52
/*:
 To find the bounds of any integer, try ".min" or ".max"
*/
UInt8.min
UInt8.max
Int32.min
Int32.max
/*:
### Floating point numbers

 Double is a 64-bit floating point number and Float is a 32-bit floating point number
*/
let pi: Double = 3.14159
let pie: Float = 100 // ... becase it's 100% delicious!
/*:
### Type Safety and Type Inference

 Swift is a strongly typed language, and as such, every stored value MUST have a type and can
 only be used where that specific type is expected.

 Integer literals are inferred to be Int
*/
let someInt = 1234
/*:
 Floating point literals are always inferred to be `Double`
*/
let someDouble = 1234.56
/*:
 If you want a `Float` instead, you must use type annotation
*/
let someFloat: Float = 1234.56
/*:
### String
 String literals are inferred to be of String type
*/
let someString = "This will be a String"
/*:
 Strings can interpolate other values using the `\\()` construct
 */
let someOtherString = "This will be a String with \(someDouble) right in the middle"
/*:
 ### Bool
 Here's a bool
*/
let someBool = true
/*:
 These lines won't compile because we are specifying a type that doesn't match the given value
```
 let someBool: Bool = 19
 let someInteger: Int = "45"
 let someOtherInt: Int = 45.6
```
### The type(of:) function
 Another useful function in Swift (we'll study more later) is the `type(of:)` function.
 To find the type of some variable say:
 */
type(of: someBool)
/*:
 Interestingly, types are themselves types, so you can ask for the type of a type.
*/
type(of: Bool.self)
/*:
 ### Numeric literals

 You can specify Integers in a few interesting ways:
*/
let decimalInteger = 17
let binaryInteger = 0b10001 // 17 in binary notation
let octalInteger = 0o21 // ...also 17 (Octal, baby!)
let hexInteger = 0x11 // ...and 17 in Hexidecimal
/*:
 Floating point numbers can be specified in a few different ways as well. Here are a few raw
 examples (not assigned to variables):
*/
1.25e2 // Scientific notation
1.25e-2
0xF
/*:
 Break the following down into "0xF", "p", "2". 
 Read as 15 (0xF) times 2 to the power (p) of 2, which is 60 decimal
 */
0xFp2 // 15 times 2 raised to the 2
0xFp-2 // 15 times 2 raised to the -2
0xC.3p0 // 12+3/16 times 2 raise to the zero
/*:
 We can pad our literals as well:
*/
000123.456 // Zero padding
0__123.456 // Underscores are just ignored
/*:
### Numeric Type Conversion

 A number that won't fit in the given type will not compile
 ```
 let cannotBeNegative: UInt8 = -1
 let tooBig: Int8 = Int8.max + 1
 ```
 Since the default type for numeric values is Int, you need to specify a different type
*/
let simpleInt = 2_000 // Int
type(of: simpleInt)
let twoThousand: UInt16 = 2_000 // Specified as UInt16
type(of: twoThousand)
let one: UInt8 = 1 // Specified as UInt8
type(of: one)
/*:
 This will infer a UInt16 based on the types of both operands
*/
let twoThousandAndOne = twoThousand + UInt16(one)
type(of: twoThousandAndOne)
/*:
 Conversions between integer and floating point types must be made explicit
*/
let three = 3 // Inferred to be Int
let pointOneFourOneFiveNine = 0.14159 // Inferred to be Double
let doublePi = Double(three) + pointOneFourOneFiveNine // Explicit conversion of Int to Double
/*:
 Important note, what we have done here is to call the initializer (we will study
 intializers in great detail later on) for Double.  Double has many 
 initializers, one of them takes an Int as an argument, in this case, the 
 stored value: `three`

 The inverse is also true - conversion from floating point to integer must be explicit

 Conversions to integer types from floating point simply truncate the fractional part. So
 doublePi becomes 3 and -doublePi becomes -3
*/
let integerPi = Int(doublePi)
let negativePi = Int(-doublePi)
/*:
 Here we have used an initializer of Int

 Literal numerics work a little differently since the literal values don't have an explicit
 type assigned to them. Their type is only inferred at the point they are evaluated.
*/
let someValue = 3 + 0.14159
