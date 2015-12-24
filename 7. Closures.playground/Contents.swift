// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Closures are blocks of code.
//
// * The can be passed as parameters to functions much like Function Types. In fact, functions
//   are a special case of closures.
//
// * Closures of all types (including nested functions) employ a method of capturing the surrounding
//   context in which is is defined, allowing it to access constants and variables from that
//   context.
// ------------------------------------------------------------------------------------------------

// Closures can use constant, variable, inout, variadics, tuples for their parameters. They can
// return any value, including Tuples. They cannot, however, have default parameters.
//
// The basic syntax is:
//
// { (parameters) -> return_type in
//   ... statements ...
// }
//
// Here's an example of a simple String comparison closure that might be used for sorting Strings:
//
// { (s1: String, s2: String) -> Bool in
//   return s1 < s2
// }
//
// Here's an example using Swift's 'sorted' member function. It's important to note that this
// function receives a single closure.
//
// These can be a little tricky to read if you're not used to them. To understand the syntax, pay
// special attention to the curly braces that encapsulate the closure and the parenthesis just
// outside of those curly braces:
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversed = [String]()
reversed = names.sorted({
    (s1: String, s2: String) -> Bool in
        return s1 > s2
})

// ------------------------------------------------------------------------------------------------
// Inferring Type from Context
//
// Like functions, closures have a type.
//
// If the type is known (as is always the case when passing a closure as a parameter to a function)
// then the return type of the closure can be inferred, allowing us to simplify the syntax of our
// call to sort.
//
// The following call is identical to the one above with the exception that "-> Bool" was removed:
reversed = names.sorted({
    (s1: String, s2: String) in
		return s1 > s2
})

// Just as the return type can be inferred, so can the parameter types. This allows us to simplify
// the syntax a bit further by removing the type annotations from the closure's parameters.
//
// The following call is identical to the one above with the exception that the parameter type
// annotations (": String") have been removed:
reversed = names.sorted({
    (s1, s2) in
		return s1 > s2
})

// Since all types can be inferred and we're not using any type annotation on the parameters,
// we can simplify a bit further by removing the paranthesis around the parameters. We'll also put
// it all on a single line, since it's a bit more clear now:
reversed = names.sorted({ s1, s2 in return s1 > s2 })

// If the closuere has only a single expression, then the return statement is also inferred. When
// this is the case, the closure returns the value of the single expression:
reversed = names.sorted({ s1, s2 in s1 > s2 })

// We're not done simplifying yet. It turns out we can get rid of the parameters as well. If we
// remove the parameters, we can still access them because Swift provides shorthand names to
// parameters passed to inline closures. To access the first parameter, use $0. The second
// parameter would be $1 and so on.
//
// Here's what that would might like (this will not compile - yet):
//
//    reversed = names.sorted({ s1, s2 in $0 > $1 })
//
// This won't compile because you're not allowed to use shorthand names if you specify the
// parameter list. Therefore, we need to remove those in order to get it to compile. This makes
// for a very short inline closure:
reversed = names.sorted({ $0 > $1 })

// Interestingly enough, the operator < for String types is defined as:
//
//     (String, String) -> Bool
//
// Notice how this is the same as the closure's type for the sorted() routine? Wouldn't it be
// nice if we could just pass in this operator? It turns out that for inline closures, Swift allows
// exactly this.
//
// Here's what that looks like:
reversed = names.sorted(>)

// If you want to just sort a mutable copy of an array (in place) you can use the sort() method
var mutableCopyOfNames = names

mutableCopyOfNames.sort(>)

mutableCopyOfNames

// ------------------------------------------------------------------------------------------------
// Trailing Closures
//
// Trailing Closures refer to closures that are the last parameter to a function. This special-case
// syntax allows a few other syntactic simplifications. In essence, you can move trailing closures
// just outside of the parameter list. Swift's sorted() member function uses a trailing closure for
// just this reason.
//
// Let's go back to our original call to sort with a fully-formed closure and move the closure
// outside of the parameter list. This resembles a function definition, but it's a function call.
reversed = names.sorted {
		(s1: String, s2: String) -> Bool in
		return s1 > s2
	}

// Note that the opening brace for the closure must be on the same line as the function call's
// ending paranthesis. This is the same functinon call with the starting brace for the closure
// moved to the next line. This will not compile:
//
// reversed = sort(names)
// {
//   (s1: String, s2: String) -> Bool in
//   return s1 > s2
// }

// Let's jump back to our simplified closure ({$0 > $1}) and apply the trailing closure principle:
reversed = names.sorted {$0 > $1}

// Another simplification: if a function receives just one closure as the only parameter, you can
// remove the () from the function call. First, we'll need a function that receives just one
// parameter, a closure:
func returnValue(f: () -> Int) -> Int
{
	// Simply return the value that the closure 'f' returns
	return f()
}

// Now let's call the function with the parenthesis removed and a trailing closure:
returnValue {return 6}

// And if we apply the simplification described earlier that implies the return statement for
// single-expresssion closures, it simplifies to this oddly-looking line of code:
returnValue {6}

// ------------------------------------------------------------------------------------------------
// Capturing Values
//
// The idea of capturing is to allow a closure to access the variables and constants in their
// surrounding context.
//
// For example, a nested function can access contstans and variables from the function in which
// it is defined. If this nested function is returned, each time it is called, it will work within
// that "captured" context.
//
// Here's an example that should help clear this up:
func makeIncrementor(forIncrement amount: Int) -> () -> Int
{
	var runningTotal = 0
	
	// runningTotal and amount are 'captured' for the nested function incrementor()
	func incrementor() -> Int
	{
		runningTotal += amount
		return runningTotal
	}

	// We return the nested function, which has captured it's environment
	return incrementor
}

// Let's get a copy of the incrementor:
var incrementBy10 = makeIncrementor(forIncrement: 10)

// Whenever we call this function, it will return a value incremented by 10:
incrementBy10() // returns 10
incrementBy10() // returns 20

// We can get another copy of incrementor that works on increments of 3.
var incrementBy3 = makeIncrementor(forIncrement: 3)
incrementBy3() // returns 3
incrementBy3() // returns 6

// 'incrementBy10' and 'incrementBy3' each has its own captured context, so they work independently
// of each other.
incrementBy10() // returns 30

// Closures are reference types, which allows us to assign them to a variable. When this happens,
// the captured context comes along for the ride.
var copyIncrementBy10 = incrementBy10
copyIncrementBy10() // returns 40

// If we request a new incremntor that increments by 10, it will have a separate and unique captured
// context:
var anotherIncrementBy10 = makeIncrementor(forIncrement: 10)
anotherIncrementBy10() // returns 10

// Our first incrementor is still using its own context:
incrementBy10() // returns 50
