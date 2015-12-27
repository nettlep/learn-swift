// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Arithmetic operators in Swift do not automatically overflow. Adding two values that overflow
//   their type (for example, storing 300 in a UInt8) will cause an error. There are special
//   operators that allow overflow, including dividing by zero.
//
// * Swift allows developers to define their own operators, including those that Swift doesn't
//   currently define. You can even specify the associativity and precedence for operators.
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// Bitwise Operators
//
// The Bitwise operators (AND, OR, XOR, etc.) in Swift effeectively mirror the functionality that
// you're used to with C++ and Objective-C.
//
// We'll cover them briefly. The odd formatting is intended to help show the results:
var andResult: UInt8 =
   0b00101111 &
   0b11110100
// 0b00100100 <- result

var notResult: UInt8 =
   ~0b11110000
//  0b00001111 <- result

var orResult: UInt8 =
   0b01010101 |
   0b11110000
// 0b11110101 <- result

var xorResult: UInt8 =
   0b01010101 ^
   0b11110000
// 0b10100101 <- result

// Shifting in Swift is slightly different than in C++.
// 
// A lesser-known fact about C++ is that the signed right-shift of a signed value is
// implementation specific. Most compilers do what most programmers expect, which is an arithmetic
// shift (which maintains the sign bit and shifts 1's into the word from the right.)
//
// Swift defines this behavior to be what you expect, shifting signed values to the right will
// perform an arithmetic shift using two's compilment.
var leftShiftUnsignedResult: UInt8 = 32 << 1
var leftShiftSignedResult: Int8 = 32 << 1
var leftShiftSignedNegativeResult: Int8 = -32 << 1

var rightShiftUnsignedResult: UInt8 = 32 >> 1
var rightShiftSignedResult: Int8 = 32 >> 1
var rightShiftSignedNegativeResult: Int8 = -32 >> 1

// ------------------------------------------------------------------------------------------------
// Overflow operators
//
// If an arithmetic operation (specifically addition (+), subtraction (-) and multiplication (*))
// results in a value too large or too small for the constant or variable that the result is
// intended for, Swift will produce an overflow/underflow error.
//
// The last two lines of this code block will trigger an overflow/underflow:
//
//	var positive: Int8 = 120
//	var negative: Int8 = -120
//	var overflow: Int8 = positive + positive
//	var underflow: Int8 = negative + negative
//
// This is also true for division by zero, which can be caused with the division (/) or remainder
// (%) operators.
//
// Sometimes, however, overflow and underflow behavior is exactly what the programmer may intend,
// so Swift provides specific overflow/underflow operators which will not trigger an error and
// allow the overflow/underflow to perform as we see in C++/Objective-C.
//
// Special operators for division by zero are also provided, which return 0 in the case of a
// division by zero.
//
// Here they are, in all their glory:
var someValue: Int8 = 120
var aZero: Int8 = someValue - someValue
var overflowAdd: Int8 = someValue &+ someValue
var underflowSub: Int8 = -someValue &- someValue
var overflowMul: Int8 = someValue &* someValue
var divByZero: Int8 = 100 &/ aZero
var remainderDivByZero: Int8 = 100 &% aZero

// ------------------------------------------------------------------------------------------------
// Operator Functions (a.k.a., Operator Overloading)
//
// Most C++ programmers should be familiar with the concept of operator overloading. Swift offers
// the same kind of functionality as well as additional functionality of specifying the operator
// precednce and associativity.
//
// The most common operators will usually take one of the following forms:
//
//  * prefix: the operator appears before a single identifier as in "-a" or "++i"
//  * postfix: the operator appears after a single identifier as in "i++"
//  * infix: the operator appears between two identifiers as in "a + b" or "c / d"
//
// These are specified with the three attributes, @prefix, @postfix and @infix.
//
// There are more types of operators (which use different attributes, which we'll cover shortly.
//
// Let's define a Vector2D class to work with:
struct Vector2D
{
	var x = 0.0
	var y = 0.0
}

// Next, we'll define a simple vector addition (adding the individual x & y components to create
// a new vector.)
//
// Since we're adding two Vector2D instances, we'll use operator "+". We want our addition to take
// the form "vectorA + vectorB", which means we'll be defining an infix operator.
//
// Here's what that looks like:
func + (left: Vector2D, right: Vector2D) -> Vector2D
{
	return Vector2D(x: left.x + right.x, y: left.y + right.y)
}

// Let's verify our work:
var a = Vector2D(x: 1.0, y: 2.0)
var b = Vector2D(x: 3.0, y: 4.0)
var c = a + b

// We've seen the infix operator at work so let's move on to the prefix and postfix operators.
// We'll define a prefix operator that negates the vector taking the form (result = -value):
prefix func - (vector: Vector2D) -> Vector2D
{
	return Vector2D(x: -vector.x, y: -vector.y)
}

// Check our work:
c = -a

// Next, let's consider the common prefix increment operator (++a) and postfix increment (a++)
// operations. Each of these performs the operation on a single value whle also returning the
// appropriate result (either the original value before the increment or the value after the
// increment.)
//
// Each will either use the @prefix or @postfix attribute, but since they also modify the value
// they are also @assigmnent operators (and make use of inout for the parameter.)
//
// Let's take a look:
prefix func ++ (inout vector: Vector2D) -> Vector2D
{
	vector = vector + Vector2D(x: 1.0, y: 1.0)
	return vector
}

postfix func ++ (inout vector: Vector2D) -> Vector2D
{
	var previous = vector;
	vector = vector + Vector2D(x: 1.0, y: 1.0)
	return previous
}

// And we can check our work:
++c
c++
c

// Equivalence Operators allow us to define a means for checking if two values are the same
// or equivalent. They can be "equal to" (==) or "not equal to" (!=). These are simple infix
// opertors that return a Bool result.
//
// Let's also take a moment to make sure we do this right. When comparing floating point values
// you can either check for exact bit-wise equality (a == b) or you can compare values that are
// "very close" by using an epsilon. It's important to recognize the difference, as there are
// cases when IEEE floating point values should be equal, but are actually represented differently
// in their bit-wise format because they were calculated differently. In these cases, a simple
// equality comparison will not suffice.
//
// So here are our more robust equivalence operators:
let Epsilon = 0.1e-7

func == (left: Vector2D, right: Vector2D) -> Bool
{
	if abs(left.x - right.x) > Epsilon { return false }
	if abs(left.y - right.y) > Epsilon { return false }
	return true
}
func != (left: Vector2D, right: Vector2D) -> Bool
{
	// Here, we'll use the inverted result of the "==" operator:
	return !(left == right)
}

// ------------------------------------------------------------------------------------------------
// Custom Operators
//
// So far, we've been defining operator functions for operators that Swift understands and
// for which Swift provides defined behaviors. We can also define our own custom operators for
// doing other interestig things.
//
// For example, Swift doesn't support the concept of a "vector normalization" or "cross product"
// because this functionality doesn't apply to any of the types Swift offers.
//
// Let's keep it simple, though. How about an operator that adds a vector to itself. Let's make
// this a prefix operator that takes the form "+++value"
//
// First, we we must introduce Swift to our new operator. The syntax takes the form of the
// 'operator' keyword, folowed by either 'prefix', 'postfix' or 'infix':
//
// Swift meet operator, operator meet swift:
prefix operator +++ {}

// Now we can declare our new operator:
prefix func +++ (inout vector: Vector2D) -> Vector2D
{
	vector = vector + vector
	return vector
}

// Let's check our work:
var someVector = Vector2D(x: 5.0, y: 9.0)
+++someVector

// ------------------------------------------------------------------------------------------------
// Precedence and Associativity for Custom Infix Operators
//
// Custom infix operators can define their own associativity (left-to-right or right-to-left or
// none) as well as a precedence for determining the order of operations.
//
// Associativity values are 'left' or 'right' or 'none'.
// 
// Precedence values are ranked with a numeric value. If not specified, the default value is 100.
// Operations are performed in order of precedence, with higher values being performed first. The
// precedence values are relative to all other precedence values for other operators. The following
// are the default values for operator precedence in the Swift standard library:
//
// 160 (none):  Operators <<  >>
// 150 (left):  Operators *  /  %  &*  &/  &%  &
// 140 (left):  Operators +  -  &+  &-  |  ^
// 135 (none):  Operators ..  ...
// 132 (none):  Operators is as
// 130 (none):  Operators < <= > >= == != === !== ~=
// 120 (left):  Operators &&
// 110 (left):  Operators ||
// 100 (right): Operators ?:
//  90 (right): Operators = *= /= %= += -= <<= >>= &= ^= |= &&= ||=
//
// Let's take a look at how we define a new custom infix operator with left associativity and a
// precedence of 140.
//
// We'll define a function that adds the 'x' components of two vectors, but subtracts the 'y'
// components. We'll call this the "+-" operator:
infix operator +- { associativity left precedence 140 }
func +- (left: Vector2D, right: Vector2D) -> Vector2D
{
	return Vector2D(x: left.x + right.x, y: left.y - right.y)
}

// Check our work. Let's setup a couple vectors that result in a value of (0, 0):
var first = Vector2D(x: 5.0, y: 5.0)
var second = Vector2D(x: -5.0, y: 5.0)
first +- second
