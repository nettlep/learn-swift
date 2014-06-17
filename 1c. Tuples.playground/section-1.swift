// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Tuples are groups of values combined into a single, compound value
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

