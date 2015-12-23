// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Tuples are groups of values combined into a single, compound value
//
// Note: Tuples are intended for temporary groups of related values.
// If your data structure is likely to persist beyond a temporary scope, 
// model it as a class or structure
// ------------------------------------------------------------------------------------------------

// Defining a Tuple - use parenthesis around the comma-delimited list of values
//
// This Tuple doesn't specify types, so it relies on inference
let httpError404 = (404, "Not found")

// We can also specify the type in order to avoid inferrence
let someOtherTuple = (Double(100), Bool(false))

// Decomposing typles looks like this
let (statusCode, statusMessage) = httpError404
statusCode
statusMessage

// We can also decompose into variables instead of constants, but you probably figured that out
var (varStatusCode, varStatusMessage) = httpError404
varStatusCode
varStatusMessage

// You can also access them with the dot operator followed by their index:
httpError404.0
httpError404.1

// Alternatively, you can name the elements of a Tuple
let namedTuple = (statusCode: 404, message: "Not found")

// When you name the elements you effectively assign names to their indices, so the dot operator
// works with names or integers:
namedTuple.statusCode == namedTuple.0
namedTuple.message == namedTuple.1

// Tuples can have any number of elements

var result = (200, "OK", true)
let (code, message, hasBody) = result

result.dynamicType  // the tuple is a new type

// If we are not interested in specific value, we can use an underscore instead of an identifier
var altResult = (404, "Not Found", false)


let (altCode, _, _) = result

// We can't compare tuples like this
// (5,5) == (5,3)

// but we can use tuples in switch statments
// example from:  https://medium.com/swift-programming/facets-of-swift-part-2-tuples-4bfe58d21abf

var point = (x: 5, y: 5)
switch point {
  case (0, 0):                        // (1)
    print("Origin")
  case (_, 0):                        // (2)
    print("On x-axis")
  case (0, _):                        // (2)
    print("On y-axis")
  case let (x, y) where x == y:       // (3)
    print("On 1. diagonal")
  case let (x, y) where x == -y:      // (3)
    print("On 2. diagonal")
  case (-1...1, -1...1):              // (4)
    print("Near origin")
  default:                            // (5)
    ()
}



