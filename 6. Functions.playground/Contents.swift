/*:
 ## Functions
 
 * Like most other languages, functions contain units of code to perform a task, but there are
   a few key featurs of functions in Swift.

 * Functions are types in Swift. This means that a function can receive another function as an
   input parameter or return a function as a result. You can even declare variables that are
   functions.

 * Functions can be nested, and the inner function can be returned by the outer function. To
   enable this, the current state of any local variables (local to the outer function) that are
   used by the inner function are "captured" for use by the inner function. Any time that inner
   function is called, it uses this captured state. This is the case even when a nested function
   is returned by the parent function.
*/
import Foundation
/*:
 ### The Basics
 
 Here's a simple function that receives a Single string and returns a String

 Note that in this case each parameter has 
 
 * a name and 
 * a standard type annotation
 
 The return value's type is at the end of the function, following the -> .
 
 Part of the declaration of every function is how it's parameters are named.  We will explore this in detail
 below.
*/
func sayHello(personName: String) -> String {
	return "Hello, \(personName)"
}
/*:
 If we call the function, we'll receive the greeting
*/
sayHello(personName: "Peter Parker")
/*:
 We can pass function invocations where before we have simply passed variables.  In this case the 
 `print` function which we hvae seen before is passed the result of calling the 
 `sayHello(personName:)`
 */
print(sayHello(personName: "John Doe"))
/*:
 Multiple input parameters are separated by a comma
*/
func halfOpenRangeLength(start: Int, end: Int) -> Int {
	return end - start
}
/*:
 A function with no parameters simply has an empty set of parenthesis following the function
 name:
*/
func sayHelloWorld() -> String {
	return "Hello, world"
}
/*:
 A funciton with no return value can be expressed in two different ways. The first is to replace
 the return type with a set of empty parenthesis, which can be thought of as an empty Tuple.
*/
func sayGoodbye(name: String) -> () { "Goodbye, \(name)" }
/*:
 We can also remove the return type (and the -> delimiter) alltogether:
*/
func sayGoodbyeToMyLittleFriend(name: String) { "Goodbye, \(name)" }
/*:
 Functions can return Tuples, which enable them to return multiple values.

 The following function simply returns two hard-coded strings.
*/
func getApplicationNameAndVersion() -> (String, String) { return ("Modaferator", "v1.0") }
/*:
 Since the return value is a Tuple, we can use the Tuple's naming feature to name the values
 being returned:
*/
func getApplicationInfo() -> (name: String, version: String) {
	return ("Modaferator", "v1.0")
}
var appInfo = getApplicationInfo()
appInfo.name
appInfo.version
/*:
 ### External and Internal Parameter Names

 We can use Objective-C-like external parameter names so the caller must name the external
 parameters when they call the function. The extenal name appears before the local name.
*/
func addSeventeen(toNumber value: Int) -> Int {
	return value + 17
}
addSeventeen(toNumber: 42)
/*:
 Note that the explicitly specified external parameter names are part of the function name.  The following
 function called `addSeventeen(to:)` is _a different_ function than `addSeventeen(toNumber:`
 */
func addSeventeen(to value: Int) -> Int { return value + 17 }
/*:
 However the following will not compile because the _internal_ name is not part of the function name
```
 func addSeventeen(to input: Int) -> Int { return input + 17 }
``` 
 So, when specifying Swift function names, you always include the external parameter names as part
 of the function name.  Typically, when speaking we will say "paren" and "colon" to delineate these
 parts of the name as necessary by context.
 
 If your internal and external names are the same, you can use a shorthand syntax to create
 both names at once.

 The following declaration creates an internal parameter named "action" as well as an external
 parameter named "action":
*/
func kangaroosCan(action: String) -> String {
	return "A Kangaroo can \(action)"
}
/*:
 We can now use the external name ("action") to make the call:
*/
kangaroosCan(action: "jump")
kangaroosCan(action: "carry children in their pouches")
/*:
 We can also have default parameter values. Default parameter values must be placed at the end
 of the parameter list.

 In the addMul routine, we'll add two numbers and multiply the result by an optional multiplier
 value. We will default the multiplier to 1 so that if the parameter is not specified, the
 multiplication won't affect the result.
*/
func addMul(firstAdder: Int, secondAdder: Int, multiplier: Int = 1) -> Int {
	return (firstAdder + secondAdder) * multiplier
}
/*:
 We can call with just two parameters to add them together
*/
addMul(firstAdder: 1, secondAdder: 2)
/*:
 We can also override the default value by passing in the value.
 */
addMul(firstAdder: 1, secondAdder: 2, multiplier: 9)
/*:
 ### Unspecified Parameter Names
 
 We can opt out of naming parameter values by specifying an
 external name of "_" like so:
*/
func anotherAddMul(firstAdder: Int, secondAdder: Int, _ multiplier: Int = 1) -> Int {
	return (firstAdder + secondAdder) * multiplier
}
/*:
 Here, we call without the third parameter as before:
*/
anotherAddMul(firstAdder: 1, secondAdder: 2)
/*:
 And now we can call with an un-named third parameter:
*/
anotherAddMul(firstAdder: 1, secondAdder: 2, 9)
/*:
 Frequently unnamed parameters will be used where the context is obvious.  `print` works 
 exactly this way.
 
 ### Variadic Parameters

 Variadic parameters allow you to call functions with zero or more values of a specified type.

 Variadic parameters appear within the receiving function as an array of the given type.

 A function may only have at most one variadic and it must appear as the last parameter.
*/
func arithmeticMean(numbers: Double...) -> Double {
	var total = 0.0
	// The variadic, numbers, looks like an array to the internal function so we can just loop
	// through them
	for number in numbers {
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}
/*:
 Let's call it with a few parameter lengths. Note that we can call with no parameters, since that
 meets the criteria of a variadic parameter (zero or more).
*/
arithmeticMean()
arithmeticMean(numbers: 1)
arithmeticMean(numbers: 1, 2)
arithmeticMean(numbers: 1, 2, 3)
arithmeticMean(numbers: 1, 2, 3, 4)
arithmeticMean(numbers: 1, 2, 3, 4, 5)
arithmeticMean(numbers: 1, 2, 3, 4, 5, 6)
/*:
 If we want to use variadic parameters and default parameter values, we can do so by making sure
 that the default parameters come before the variadic, at the end of the parameter list:
*/
func anotherArithmeticMean(initialTotal: Double = 0, numbers: Double...) -> Double {
	var total = initialTotal
	for number in numbers {
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}
/*:
 Here, we can still call with no parameters because of the default parameter
*/
anotherArithmeticMean()
/*:
 Going forward, we must specify the default parameter's external name (because we didn't opt-out
 of it.) Also, you can see why Swift attempts to enforce the use of external parameter names for
 default parameter values. In this case, it helps us recognize where the defalt parameters leave
 off and the variadic parameters begin:
*/
anotherArithmeticMean(initialTotal: 1)
anotherArithmeticMean(initialTotal: 1, numbers: 2)
anotherArithmeticMean(initialTotal: 1, numbers: 2, 3)
anotherArithmeticMean(initialTotal: 1, numbers: 2, 3, 4)
anotherArithmeticMean(initialTotal: 1, numbers: 2, 3, 4, 5)
anotherArithmeticMean(initialTotal: 1, numbers: 2, 3, 4, 5, 6)
/*:
 Variadic parameters with external parameter names only apply their external name to the first
 variadic parameter specified in the function call (if present.)
*/
func yetAnotherArithmeticMean(initialTotal: Double = 0, values numbers: Double...) -> Double {
	var total = initialTotal
	for number in numbers {
		total += number
	}
	return numbers.count == 0 ? total : total / Double(numbers.count)
}
/*:
 And here we can see the impact on the function call of adding the external name "values" to the
 variadic parameter:
*/
yetAnotherArithmeticMean()
yetAnotherArithmeticMean(initialTotal: 1)
yetAnotherArithmeticMean(initialTotal: 1, values: 2)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4, 5)
yetAnotherArithmeticMean(initialTotal: 1, values: 2, 3, 4, 5, 6)
/*:
 ### Constant and variable parameters

 All function parameters are constant by default. A common pattern is to create variable of the
 same name as the passed in parameter which much be treated as a let.  This makes a variable copy
 of the parameter which will be used throughout the rest of the function scope.
*/
func padString(str: String, pad: Character, count: Int) -> String {
    var str = str
    str = String(repeating: String(pad), count: count) + str
    return str
}

var paddedString = "padded with dots"
padString(str: paddedString, pad: ".", count: 10)
/*:
 Note that this function does not modify the caller's copy of the string that was passed in
 because the value is still passed by value:
*/
paddedString
/*:
 ### In-Out Parameters

 In-Out parameters allow us to force a parameter to be passed by reference so those changes can
 persist after the function call.

 Note that inout parameters cannot be variadic or have default parameter values.

 We'll write a standard swap function to exercise this:
*/
func swap(a: inout Int, b: inout Int) {
	let tmp = a
	a = b
	b = tmp
}
/*:
 Let's call the swap function to see what happens.

 To ensure that the caller is aware that the parameter is an inout (and hence, can modify their
 variable), we must prefix the parameter name with "&".

 Note that the variables that will be passed as references may not be defined as constants,
 because it is expected that their values will change:
*/
var one = 1, two = 2
swap(&one, &two)
/*:
 And we can see that 'one' contains a 2 and 'two' contains a 1:
*/
one
two
/*:
 ### Function types

 The type of a function is comprised of the specific parameter list (the number of parameters as
 well as their type) and the return value's type.

 The following two functions have the same type.

 It's important to note that their type is described as: (Int, Int) -> Int
*/
func add(a: Int, b: Int) -> Int { return a + b }
func mul(a: Int, b: Int) -> Int { return a * b }
/*:
 A function that has no parameters or return value would have the type: () -> ()
*/
func nop() -> () { return }
/*:
 The type of the function below is the same as the one above: () -> ()

 It is written in a shorter form, eliminating the return type entirely, but this syntactic
 simplification doesn't alter the way that the function's type is notated:
*/
func doNothing() { return }
/*:
 Using what we know about funciton types, we can define variables that are the type of a function
*/
let doMul: (Int, Int) -> Int = mul
/*:
 We can now use the variable to perform the function:
*/
doMul(4, 5)
/*:
 We can also name our parameters when assigning them to a variable, as well as taking advantage
 of un-named parameters ("_").

 This additional syntactic decoration has a purpose, but it doesn't affect the underlying
 function type, which remains: (Int, Int) -> Int
*/
let doAddMul: (_ a: Int, _ b: Int, Int) -> Int = addMul
/*:
 Calling the function now requires external names for the first two parameters
*/
doAddMul(4, 2, 55)
/*:
 We can pass function types as parameters to funcions, too.

 Here, our first parameter named 'doMulFunc' has the type "(Int, Int) -> Int" followed by two
 parameters, 'a' and 'b' that are used as parameters to the 'doMulFunc' function:
*/
func doDoMul(doMulFunc: (Int, Int) -> Int, a: Int, b: Int) -> Int {
	return doMulFunc(a, b)
}
/*:
 We can now pass the function (along with a couple parameters to call it with) to another
 function:
*/
doDoMul(doMulFunc: doMul, a: 5, b: 5)
/*:
 We can also return function types.

 The syntax looks a little wird because of the two sets of arrows. To read this, understand that
 the first arrow specifies the return type, and the second arrow is simply part of the function
 type being returned:
*/
func getDoMul() -> (Int, Int) -> Int {
	return doMul
}
let newDoMul = getDoMul()
newDoMul(9, 5)
/*:
 Or, an even shorter version that avoids the additional stored value:
*/
getDoMul()(5, 5)
/*:
 Earlier we discussed how functions that do not return values still have a return type that
 includes: -> ()

 Here, we'll see this in action by returning a function that doesn't return a value:
*/
func getNop() -> () -> () {
	return nop
}
/*:
 And we'll call nop (note the second set of parenthesis to make the actual call to nop())
*/
getNop()()
/*:
 We can nest functions inside of other functions:
*/
func getFive() -> Int {
	func returnFive() -> Int {
		return 5
	}
	// Call returnFive() and return the result of that function
	return returnFive()
}
/*:
 Note that there is no way to access the `returnFive()` function from outside of `getFive()`.  
 `returnFive()` is available _ONLY_ within the scope of `getFive()`
 
 Calling getFive will return the Int value 5:
*/
getFive()
/*:
 You can return nested functions, too:
*/
func getReturnFive() -> () -> Int {
	func returnFive() -> Int {
		return 5
	}
	return returnFive
}
/*:
 Calling outerFunc2 will return a function capable of returning the Int value 5:
*/
let returnFive = getReturnFive()
/*:
 Here we call the nested function:
*/
returnFive()
/*:
 ### Guard
 
 One very important pattern for functions is the `guard` construct.
 Guard is like an `if` statement turned inside out and works as follows:
 
 * if the the accompanying expression evaluates as true
 continue to the next statement.  
 
 * If not, perform the else statement
 
 * Guard statements _ALWAYS_ have an else statement associated with them.
 
 Like if-let, you can have guard-let, but there are subtle differences.
 Variables defined in a guard-let, unlike with if-let are available to the rest
 of the scope, but are NOT available in the else branch.
 
 Else statements associated with a guard _MUST_ exit the code block in which
 the guard statement occurs. They can do this with by invoking `return` (in 
 a function), `break` or `continue` (in an appropriate control-flow 
 statement, or `throw` (in a scope declaring throws), or they can call 
 a function or method that doesn’t return, such as fatalError(_:file:line:).
 
 Guard statements typically:
 
 * occur at the top of a function 
 
 * verify validity of arguments
 
 * remove optionality from passed in arguments
*/
func hasValue(_ string: String?) -> Bool {
    // note that we use guard to redefine "string" to be non-optional
    guard let string = string else { return false }
    return string.count > 0
}

hasValue(nil)
hasValue("")
hasValue("some string")
/*:
 ### Defer
 
 A `defer` statement defers execution of some block of code until the
 current scope is exited. This statement consists 
 of the `defer` keyword and the block statements to be
 executed later. 
 
 The deferred statements may not
 contain any code that would transfer control 
 out of the statements, such as a break or a return 
 statement, or by throwing an error. 
 
 Deferred actions are executed in reverse order of how they
 are specified—that is, the code in the first defer 
 statement executes after code in the second, and 
 so on.
*/
func processFile(filename: String) throws {
    let fm = FileManager.default
    if fm.fileExists(atPath: filename) {
        guard let file = FileHandle(forReadingAtPath: filename) else { return }
        defer {
            file.closeFile()
        }
        while file.readData(ofLength: 1).count != 0 {
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
