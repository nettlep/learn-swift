// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Assuming knowledge of C here, so a lot will be left out that is the the same, such as
//   "let i = 1 + 2"
//
// * Unary operators work on a single target. Of them, you have prefix operators such as !b or
//   postfix operators such as i++.
//
// * Binary operators work on two targets and are infix operators because they go between two
//   values, such as a + b
//
// * Ternary operators work on three targets. There is only one ternary: a ? b : c.
// ------------------------------------------------------------------------------------------------

// We have our standard assignment operator (=). Note that the assignment operator in Swift does
// not actually return a value, so the statment "if (x = y) {}" will not work. This helps prevent
// accidental assignments during conditionals.
var a = 10.0
var b = 3.0

// Assignment can also take multiple values (for Tuples):
let (x, y) = (5, 6)
x
y

// Aside from the standard mathematics operators (+, -, /, *), there is also the remainder operator
// (%) which is not to be confused with modulo. They work differently because of the way remainders
// are calculated for negative numbers and can be used with floating point values.
var c = a / b // Floatng point result
var d = a % b // Floating point remainder

// ------------------------------------------------------------------------------------------------
// Range operators
//
// The range operator with two dots means up to but NOT including the final value.
//
// This is called the "Half-Closed Range Operator"
for i in 1..<10
{
	i // prints 1 through 9
}

// The range operator with three dots is inclusive with last value like
//
// This is called the "Closed Range Operator"
for i in 1...10
{
	i // prints 1 through 10
}

// ------------------------------------------------------------------------------------------------
// Unary, Binary and Ternary operators
//
// Unary prefix operators appear before their taget. Here we increment a then negate it:
++a
a = -a

// You can also use the uniary + operator, though it doesn't do anything
a = +a

// We have the compound assigment operator
a += 10

// The logical NOT
var truefalse = true
truefalse = !truefalse

// Unary postfix operators appear after their target: i++
a--
a

// Binary operators are infix because they appear between to targets
a + b

// String concatenation uses the + operator:
"hello, " + "world"

// To add characters, convert them to a string
let dog: Character = "🐶"
let cow: Character = "🐮"
let dogCow = String(dog) + String(cow)

// Ternary operators work on three targets:
truefalse ? a : b

// ------------------------------------------------------------------------------------------------
// Identity operators
//
// We can test if the object reference refers to the same instance of an object (as opposed to two
// objects that are "equivalent" based on some compare logic.) We do this with the === operator:
class myclass {}
var c1 = myclass()
var c2 = myclass()
c1 === c2
c1 === c1

// String comparisons are case sensitive
"abc" == "abc"
"abc" == "ABC"

// ------------------------------------------------------------------------------------------------
// Logical operators
//
// Comparisons use the logical operators with AND, OR and NOT
if (true && false) || !(false && true)
{
	"true"
}
