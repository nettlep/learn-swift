/*:
  ## Closures
  
 * Closures are simply anonymous blocks of code.

 * They can be passed as parameters to functions much like Function Types. In fact, functions
   are a jsut special case of closures.  
 
 * Closures are just anonymous functions.  
 
 * Alternatively, functions are simply named closures with special syntax for the 
   application of the name.

 * Closures of all types (including nested functions) employ a method of capturing the surrounding
   context in which the closure is defined.  This allows the closure to access constants and variables 
   from that context.  In fact, the reason that they are called closures is that they "enclose" 
   the code AND the captured context.
 
 * Capture occurs at the time the closure is created.
 
 * Understanding the capture rules is extremely important to understanding the use of closures.
 
 * Closures can use all the same types (i.e. any type) as functions
   for their parameters. They can return any value, including Tuples, just like functions.
 
 * Closures cannot have default parameters.

 The basic syntax of a closure is:
```
 { (parameters) -> return_type in
   ... statements ...
 }
```
 Below is an example of a simple String comparison closure that might be used for sorting Strings:
```
 { (s1: String, s2: String) -> Bool in
   return s1 < s2
 }
```
 Here's an example using Swift's 'sorted' function on an array. It's important to note that this
 function receives a single closure as an argument.

 These can be a little tricky to read if you're not used to them. To understand the syntax, pay
 special attention to the curly braces that encapsulate the closure and the parenthesis just
 outside of those curly braces:
*/
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversed = [String]()
/*:
 Note that the `sorted(by:)` takes one argument, a function of type `(s1: String, s2: String) -> Bool`.
 Closures allow us to put this function argument right inside the parentheses, just as if we were sending
 and Int or String to `sorted(by:)`
*/
reversed = names.sorted(by: {
  (s1: String, s2: String) -> Bool in
    return s1 > s2
})
/*:
 The "in-line" nature of the closure is very important.
 
 ### Inferring Type from Context

 Like functions, closures have a type.

 If the type is known (as is always the case when passing a closure as a parameter to a function)
 then the return type of the closure can be inferred, allowing us to simplify the syntax of our
 call to sort.

 The following call is identical to the one above with the exception that "-> Bool" was removed:
 */
reversed = names.sorted(by: { (s1: String, s2: String) in return s1 > s2 })
/*:
 Just as the return type can be inferred, so can the parameter types. This allows us to simplify
 the syntax a bit further by removing the type annotations from the closure's parameters.

 The following call is identical to the one above with the exception that the parameter type
 annotations (": String") have been removed:
*/
reversed = names.sorted(by: { (s1, s2) in return s1 > s2 })
/*:
 Since all types can be inferred and we're not using any type annotation on the parameters,
 we can simplify a bit further by removing the paranthesis around the parameters.
*/
reversed = names.sorted(by: { s1, s2 in return s1 > s2 })
/*:
 If the closure has only a single expression, then the return statement is also inferred. When
 this is the case, the closure returns the value of the single expression:
*/
reversed = names.sorted(by: { s1, s2 in s1 > s2 })
/*:
 We're not done simplifying yet. It turns out we can get rid of the parameters as well. If we
 remove the parameters, we can still access them because Swift provides shorthand names to
 parameters passed to closures. To access the first parameter, use $0. The second
 parameter would be $1 and so on.

 Here's what that would might like (this will not compile - yet):
```
    reversed = names.sorted({ s1, s2 in $0 > $1 })
```
 This won't compile because you're not allowed to use shorthand names if you specify the
 parameter list. Therefore, we need to remove those in order to get it to compile. This makes
 for a very short inline closure:
*/
reversed = names.sorted(by: { $0 > $1 })
/*:
 Interestingly enough, the operator < for String types is defined as:
```
     (String, String) -> Bool
```
 Notice how this is the same as the closure's type for the sorted(by:) routine? Wouldn't it be
 nice if we could just pass in this operator? It turns out that for inline closures, Swift allows
 exactly this.

 Here's what that looks like:
*/
reversed = names.sorted(by: > )
/*:
 If you want to just sort a mutable copy of an array (in place) you can use the sort() method
*/
var mutableCopyOfNames = names
mutableCopyOfNames.sort(by: >)
mutableCopyOfNames
/*:
 The important thing to note about this particular trick is that (as we'll learn when we discuss
 operators) is that in a sense we are no longer using a closure.  It turns out that `>` is a
 named function that is of exactly the type required, i.e. `(String, String) -> Bool`, so we
 have returned in that call to actually passing a named function rather than a closure.
 
 ### Trailing Closure Syntax

 As in the old Saturday Night Live skit: "But wait! There's less!"
 
 Trailing Closures refer to closures that are the last parameter to a function. This special-case
 syntax allows a few other syntactic simplifications. In essence, you can move trailing closures
 just outside of the parameter list. Swift's sorted() member function uses a trailing closure for
 just this reason.

 Let's go back to our original call to sort with a fully-formed closure and move the closure
 outside of the parameter list. This resembles a function definition, but it's a function call.
*/
reversed = names.sorted() { (s1: String, s2: String) -> Bool in return s1 > s2 }
reversed
/*:
 Note that the opening brace for the closure must be on the same line as the function call's
 ending paranthesis. This is the same functinon call with the starting brace for the closure
 moved to the next line. This will not compile:
```
 reversed = names.sorted()
 { (s1: String, s2: String) -> Bool in return s1 > s2 }
```
 Let's jump back to our simplified closure ({$0 > $1}) and apply the trailing closure principle:
*/
reversed = names.sorted() { $0 > $1 }
reversed
/*:
 Another simplification: if a function receives just one closure as the only parameter, you can
 remove the () from the function call.
*/
reversed = names.sorted { $0 > $1 }
reversed
/*:
 Now let try this with our own function. First, we'll need a function that receives just one
 parameter, a closure:
 */
func returnValue(f: () -> Int) -> Int
{
	// Simply return the value that the closure 'f' returns
	return f()
}
/*:
// Now let's call the function with the parenthesis removed and a trailing closure:
*/
returnValue { return 6 }
/*:
 And if we apply the simplification described earlier that implies the return statement for
 single-expresssion closures, it simplifies to this oddly-looking line of code:
*/
returnValue { 6 }
/*:
 The very important point about trailing closure syntax is that you must learn to recognize it
 if you want to read and write colloquial Swift.  Basically any time you see a `{ ... }` usage that
 don't recognize you are very likely looking at trailing closure syntax and you need to be 
 thinking of a function being passed as an argument to another function
 
 ### Capturing Values

 The idea of capture is to allow a closure to access the variables and constants in their
 surrounding context.

 For example, a nested function can access contstans and variables from the function in which
 it is defined. If this nested function is returned, each time it is called, it will work within
 that "captured" context.

 Here's an example that should help clear this up:
 */
func makeIncrementor(forIncrement amount: Int) -> () -> Int {
	var runningTotal = 0
	// runningTotal and amount are 'captured' for the nested function incrementor()
	func incrementor() -> Int {
		runningTotal += amount
		return runningTotal
	}
	// We return the nested function, which has captured it's environment
	return incrementor
}
/*:
 Let's get a copy of the incrementor:
*/
var incrementBy10 = makeIncrementor(forIncrement: 10)
/*:
 Whenever we call this function, it will return a value incremented by 10:
*/
incrementBy10() // returns 10
incrementBy10() // returns 20
/*:
 The important point that always confuses people is that a new closure is created
 at EVERY invocation of makeIncrementor.  When the closure is created, it "captures"
 all of the variables that it uses, with their current values, AT THE POINT OF INVOCATION.
 
 So in this case, what's happening is that `makeIncrementor`, as its name suggests, makes
 a new closure and returns it every time that `makeIncrementor` is invoked.  That new closure
 captures a copy of runningTotal which has a value of 0 at that time.  Every time that 
 particular instance of the closure is invoked, it increments it's own copy of running
 total and increments it by the forIncrement argument.
 
 We can get another copy of incrementor that works on increments of 3.
*/
var incrementBy3 = makeIncrementor(forIncrement: 3)
incrementBy3() // returns 3
incrementBy3() // returns 6
/*:
 'incrementBy10' and 'incrementBy3' each has its own captured context, so they work independently
 of each other.
*/
incrementBy10() // returns 30
/*:
 Closures are reference types, which allows us to assign them to a variable. When this happens,
 the captured context comes along for the ride.
*/
var copyIncrementBy10 = incrementBy10
copyIncrementBy10() // returns 40
/*:
 If we request a new incremntor that increments by 10, it will have a separate and unique captured
 context:
*/
var anotherIncrementBy10 = makeIncrementor(forIncrement: 10)
anotherIncrementBy10() // returns 10
/*:
 Our first incrementor is still using its own context:
*/
incrementBy10() // returns 50
/*:
 ### Closures are Reference Types
 
 “Whenever you assign a function or a closure to a constant or a variable, you are actually setting that constant or variable to be a reference to the function or closure. In the example above, it is the choice of closure that incrementByTen refers to that is constant, and not the contents of the closure itself.
 
 This also means that if you assign a closure to two different constants or variables, both of those constants or variables will refer to the same closure”
 
 _Excerpt From: Apple Inc. “The Swift Programming Language (Swift 3.0.1).”_

 ### Escaping Closures
 
 
 
 */

