/*:
 # Higher Order Functions II: Functions Returning Functions
 ### (aka Functional Composition)
 
The point of this playground is to demonstrate Swift's capabilities to
 "reshape" functions - also known as functional composition.
 
 This feature is generally what people are referring to when they
 speak of `functional programming`. Its use informs the entire style.
 
 So... Lets start with a  function.  This one extends `Array<Int>` and
 basically gives us `compactMap` to play with.  (I'll explain much later
 in detail why we can't just use compactMap itself, but for now just note
 that its because compactMap is a generic function).
 */
extension Array where Element == Int {
    func myCompactMap(_ transform: (Int) -> String?) -> [String] {
        compactMap(transform)
    }
}

let f = [Int].myCompactMap
/*:
 Take a look at the far right column of the playground.  Expand that column
 so that you can see the type of `f` there.
 To remind, the type of `f` is *_NOT_* `function`.  The type of `f` is that entire
 string of things produced in the results column of the playground to the right.
 Look very carefully at the type of of this expression as it might surprise you,
 Here it is printed for you:
```
    ([Int]) -> (Int -> String?) -> [String]
```
Two questions that should be in your mind are:
 
 1. wtf? with the multiple `->`'s? and
 
 2. why do I have ([Int]) at the beginning?
 
 In words this function signature is:
```
 a function which takes [Int] and returns:
    a function which takes:
          (a function which takes an Int and returns String?)
       and returns:
          [String]
```
 Eventually in Swift, you have to understand functions which take functions AND
 functions which return functions. And even more you have to understand
 how they chain.

 Interestingly, there are several ways syntactically to invoke that function that
 we captured as `f`. Look at the lines below and their type signatures.
 All of these statements are exactly the same.  The ONLY difference
 is that f1a is in OOP notation. But the compiler turns them into the exact same code.
*/
let f1a = [1,2,3].myCompactMap
let f1b = [Int].myCompactMap([1,2,3])
let f1c = f([1,2,3])
/*:
In words these are all functions which
 ```
    take:
       (a function which takes an Int and returns String?)
    and return:
       [String]
 ```
i.e. they are the original `f` function with the first part cut off.  As you would expect because we've taken the first function and done an invocation on it.

 Note that I refer above to the `OOP notation`.  In Swift, OOP is just that, a notation, nothing more, nothing less.  This one of the primary lessons
 of this playground, btw.
 
 So lets invoke the 3 functions above.  Ok!  now we have some values.  And look, they're all the same.
 */
let r1 = [1,2,3].myCompactMap { "\($0)" }
r1
let r2 = [Int].myCompactMap([1,2,3])( { "\($0)" } )
r2
let r3 = f([1,2,3])( { "\($0)" } )
r3
/*:
 NB these functions are the same.
*/
f1a { "\($0)" }
f1b { "\($0)" }
f1c { "\($0)" }
/*:
 Look at the type signature of `f` again.  To remind, it is:
 
 `([Int]) -> ((Int) -> String?) -> [String?]`

 Amazingly it is possible to write a Swift function which can
 invert the order of those arguments to:

 ` ((Int) -> String?) -> ([Int]) -> [String?]`
 
 Here it is:
 */
public func flip<A, B, C>(
    _ function: @escaping (A) -> (C) -> B
) -> (C) -> (A) -> B {
    { (c: C) -> (A) -> B in
        { (a: A) -> B in
            function(a)(c)
        }
    }
}
/*:
 This is our first real example of functional composition.  Using a function to change
 the "shape" of another function.  This particular example rewards paying it a lot of
 attention.
 
 We have 3 functions here:
 
 1. the function that begins: `public func flip<A, B, C>(`
 
 2. the one that begins: `{ (c: C) -> (A) -> B in`
 
 3. the one that begins: `{ (a: A) -> B in`
 
 When invoked, function 1 returns function 2.  If you then invoke function 2, it
 returns function 3. If at the end of everything, you invoke function 3, you will
 _finally_ have a type that is not a function of some sort, you will have an
 "honest" value of type B. (of course B could be a function  :) )
 
 To prove it does what I said, look at the function signatures here where I have
 invoked function 1:
 */
let f2   = flip(f)
let f2a  = flip([Int].myCompactMap)
/*:
 Now lets use it that way by invoking function 2...
 */
let f3   = f2  { "\($0)" }
f3
let f3a  = f2a { "\($0)" }
f3a
/*:
Now lets take the final step and invoke function 3...
*/
f3([1,2,3])
f3a([1,2,3])
/*:
 Ok, you ask, this is all nice and everything, but it seems kind of
 academic, where would _ANYONE_ ever use this stuff.  Well, it turns out
 that Swift itself uses this stuff as should be obvious from above where we typed:
 
    `[Int].myCompactMap`
 
 and got back a function returning a function. So lets explore that a bit more.
 
 Lets define some structs of our own with some functions
 */
struct StructA {
    var a: String = "An A"
    func append(string: String) -> String {
        return a + string
    }
}

type(of: StructA.append)
let a = StructA(a: "some string")
/*:
 Note that these are exactly the same
*/
let s1 = StructA.append(a)(string:" 5")
let s2 = StructA(a:"some string").append(string: " 5")
/*:
 now look at the following extension.
 */
extension StructA {
    static func staticAppend(a: StructA) -> (String) -> String {
        let `self` = a
        return { string -> String in
            return `self`.a + string
        }
    }
}
/*:
 Lets get the signature of _THAT_
 */
type(of: StructA.staticAppend)
type(of: StructA.append)
/*:
 If you look at _THOSE_ type signatures, you'll find that they fit our `flip` function above
 perfectly.  i.e. we could shift around the order of the arguments if we found that convenient.
 
 But the big lesson here is that we can write our own static functions that
 bind `self` and they behave _precisely_ the way that "objects" do.  i.e.
 everything you think of as an "instance method" is actually a
 function returning a function where Swift has passed in "self" to the first function, which
 has bound it and returned the function that you think of as the "method". (The compiler
 optimizes the hell out of this for your methods, so it's not literally true underneath,
 but from a syntactic standpoint, they are exactly the same).
 
 If you are familiare with ObjC, this is _exactly_ equivalent to what
 it does when it passes self as the first argument to an Impl.  Swift
 just uses a different technique for designating `self`.  And it turns
 out that that technique is just a use of functional composition.
 
 But... we can in fact do what ObjC does, too.  Let's write a function for that.
 */
public func uncurry<A, B, C>(
    _ function: @escaping (A) -> (B)  -> C
) -> (A, B) -> C {
    { (a: A, b: B) -> C in function(a)(b) }
}
/*:
 This one takes as its only argument a function returning a function
 where the arguments to the passed in function are single values and it
 combines them to make a single function that takes two arguments.
 Lets try it.
 */
let u = uncurry(StructA.append)
type(of: u)
/*:
 Look at the output of that `type(of:)`.  If you are familiar with other OO
 languages like ObjectiveC, it should remind you of exactly what those languages
 do to provide method invocation.
 
 To reiterate, we just turned `StructA.append` into an ObjC-style Impl where `self`
 is the first argument.  Hmm..  What can be seen here is that everything you think
 of as OOP is in fact a specific notation that can be derived by manipulating
 functions and seasoning to taste with syntactic sugar.  What Swift has done
 is promote these techniques from being compiler magic to being run-of-the-mill,
 garden variety, language features.

 And.... just for kicks, lets undo what we just did.
 */
public func curry<A, B, C>(
    _ function: @escaping (A, B) -> C
) -> (A) -> (B) -> C {
    { (a: A) -> (B) -> C in { (b: B) -> C in function(a, b) } }
}

let c = curry(u)
type(of: c)
/*:
 And we see that c recovers the shape of the original function.
 
 This sort of "shape manipulation" is an incredibly powerful feature
 that allows you to glue existing functions together in really interesting ways.
 
 NB, everything we've just done, could also be done in e.g. ObjC.
 There are two differences (and the differences are the entire
 reason that these techniques are not used there):
 
 1. generics and
 2. syntax.
 
 `flip`, `curry` and `uncurry` are real
 generic functions with reified implementations created on demand.
 Unlike in Java or ObjC, they are not just hints to the compiler.
 Reified generics are precisely what is required to remove the boiler-
 plate code necessary to reshape functions in a general sense.  Without it
 you end up writing custom code to reshape functions the way that you want
 and that custom code is just too cumbersome to implement in the volume
 you would need. And the syntax of swift is _designed_ to make this use
 of generics and this sort of reshaping easy.
 
 In fact, [this NSHipster article](https://nshipster.com/callable/) is
 an excellent explantion of what the syntactic sugar here is doing and
 why it is so useful.
 
 Let's do one more function that comes in useful in this regard, forward composition,
 which we'll describe as the `>>>` operator.
 */

precedencegroup CompositionPrecedence {
  associativity: right
  higherThan: AssignmentPrecedence
  lowerThan: MultiplicationPrecedence, AdditionPrecedence
}
infix operator >>>: CompositionPrecedence

func >>> <A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C
) -> (A) -> C {
    { (a: A) -> C in g(f(a)) }
}
/*:
 Note that all this function does is take two functions which
 fit together (f outputs g's input type) and roll them up into
 one function.

 Here's an example:
 */
let left = { (a: Int) -> Double in Double(2 * a) }
type(of: left)

let right = { (b: Double) -> String in "\(b)" }
type(of: right)

(left >>> right)(4)
type(of: left >>> right)

let combined = left >>> right
type(of: combined)
combined(4)
combined(5)
/*:
 So look closely at that line:
 
     `let combined = left >>> right`
 
 Using a functional composition technique,
 we were able to combine two functions together without invoking
 either one.
 
 This gave us a single function we could then invoke
 at our leisure.  Which we then do with the lines:
 ```
 combined(4)
 combined(5)
 ```
 
 And now... we are ready to talk about what Combine does.
 */
