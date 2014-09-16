// ------------------------------------------------------------------------------------------------
//    ____                            _       _
//   / ___|___  _ __   __ _ _ __ __ _| |_ ___| |
// 	| |   / _ \| '_ \ / _` | '__/ _` | __/ __| |
//  | |__| (_) | | | | (_| | | | (_| | |_\__ \_|
//   \____\___/|_| |_|\__, |_|  \__,_|\__|___(_)
//                    |___/
//
//                                                You've made it to the end!
//
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// There's Still More To Learn
//
// These playgrounds are taken directly from the Language Guide section of Apple's book titled
// "The Swift Programming Language".
// 
// The book also includes a Language Reference, which discusses the language in a more terse form
// with greater detail (including the grammar.) It's not as dry as reading the C++ Ansi Spec, but
// it's still rather detailed. In fact, some of the information from these playgrounds came from
// the Language Reference section.
//
// The good news is that having managed to get through these playgrounds, you'll probably find
// the Language Reference to be rather quick reading, chock full of additional goodies that you
// never knew about (because the Language Guide and these Playgrounds don't touch on.)
//
// For example, how would you code the assert function such that the first parameter is executed
// and evaluated to a Bool for use in determining an error condition?
var pi = 3.14159
assert(pi > 3.14, "Pi is too small")

// Do you know why this compiles?
func doSomeMagic(#a: Int)(b: Int) -> Int
{
	return a + b
}

// ...or why it can be executed like this?
doSomeMagic(a: 10)(b: 10)

// You'll also learn about Metatypes and did you know that Swift's operator precedence is slightly
// different than C?
//
// This is clearly stuff you should know before submitting your forehead to the wall.
//
// You'll learn about these constants:
__FILE__ + "(" + String(__LINE__) + "): " + __FUNCTION__ + ":" + String(__COLUMN__)

// Furthermore, don't let somebody else's code confuse you when you see something like this in
// their code and realize that it actually compiles!
var ohrly = pi.dynamicType.infinity

// Most importantly, you'll solidify your understanding of the concepts that were presented in
// these playgrounds.
//
// Happy coding!
//
// - Paul Nettle
