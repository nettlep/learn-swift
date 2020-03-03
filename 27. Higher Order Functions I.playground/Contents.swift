/*:
 # Higher Order Functions I
 
 ### Functions Taking Functions as Arguments
 
 This is Part 1 of an introduction to Swift's feature set for
 writing functions which take other
 functions as arguments and/or return functions as return values.
 Such functions are referred to as "higher order" functions for obvious reasons.
 It has been my experience when teaching Swift
 that this is the single hardest concept for students to grasp.
 Because of that, I recommend that you look closely at every
 line of code in this and the next playground, making sure that you understand
 what it is doing before proceeding. The material involved builds up at every step
 and you'll need to keep in mind several new things in order to follow the flow.
 
 People always start a discussion of higher order functions
 with the family of functions which operate
 on the Sequence protocol.  Our discussion will lean on these heavily as an example
 as well, but be prepared to move beyond them quickly.
 
 You should keep in mind that this playground
 is only half the story because the functions
 we are studying here are those
 functions which accept a function as an argument and return a struct,
 class or enum type.
 (In the case of Sequence the type returned is an Array)
 The true power of higher order functions only comes into focus in the
 next playground when we write functions that not only accept a single
 function as an argument, but which take _multiple_ functions as arguments,
 compose the arguments together somehow and return a function as a result.
 These patterns of function composition are critical to absorb to be able to even
 read idiomatic Swift, much less write it.
 
 The power of this approach is amplified even more when it is combined with Swift's
 generic programming capability which we utilize fully in this playground.  You may
 want to keep "Playground 22. Generics" handy while we do this.
 
 So... let's start with a simple function which takes a function as an argument:
 */
func f(_ value: Int, _ g: (Int) -> Double) -> String { "\(g(value))" }
type(of: f)
/*:
 Note that f takes _TWO_ arguments.  The first is internally named `value` and the
 second is internally named `g`. Note that `value` is of type Int, and that `g` is of type:
 `function taking Int returning Double`.
 
 It is _VERY_ important that you understand that last sentence. `f` and `g` are NOT
 simply of type `function`.  There is no type that is just `function`.
 The type of a function is denoted in spoken language as:
 
 `function taking [LIST OF ARGUMENT TYPES] and returning [RETURN_TYPE]`.
 
 in pseudo-code:
 
 `(([LIST OF ARGUMENT TYPES]) -> [RETURN_TYPE]`).Type
 
 The latter is what you will see in the right hand column of the playground when
 we ask for `type(of: someFunction)`.
 
 You _must_ say the entire phrase to correctly specify the type of a function.
 The Swift type system distinguishes function types on just that basis and will
 give you error messages anywhere you try to substitute a function which does
 not have the correct type.
 
 If you look closely at the `type(of:)` call for f, you will see that its type is
 precisely what I have specified.  So lets play with `f` a bit. Let's start
 by showing the various ways it can be called.  So let's make some funcs to use
 as `g`'s.
 */
func g(_ i: Int) -> Double { Double(i) }
var j = 12
let h = { (i: Int) -> Double in Double(j * i) }
/*:
 I've intentionally chosen awful names here to demonstrate that the names of the functions
 really don't matter to the type system.
 
 I've also intentionally done several things to illustrate the various syntactic
 forms that functions take underneath the covers of Swift.  Be aware that to the
 type system, these all look alike.
 
 First note that `g` is defined
 as a top-level func.  You can use it anywhere in this playground by name.
 
 Secondly, note that h is a closure `let` rather than a func declaration.  Swift
 doesn't really care.  The `func` keyword is there for your convenience not Swift's
 and it specifies a certain set of capture rules to facilitate your usage.
 
 Lastly, note that `h` _captures_ the variable `j` which is currently 12.
 If this confuses you, you should go back and review capture rules in Playgrounds
 6 and 7.

 And let's verify the types.
 */
type(of: g)
type(of: h)
/*:
 Those look right.
 
 If we call `g` and `h` with the same value we find out that `h` will indeed use the
 value of `j` that was defined outside the function.
 */
g(4)
h(4)
/*:
 So now, lets use `f` in several different ways.
 */
f(4, g)               // pass the second variable as a func
f(4, h)               // pass the second variable as a named closure variable
f(4, { Double($0) } ) // pass the second variable as an anonymous closure
f(4) { Double($0) }   // pass the 2nd variable in trailing closure syntax
/*:
 So we have built a function that takes a function as an argument and shown its use
 in four different syntactic forms.  I have made the forms here as simple as possible,
 they can get much more complex.  You need to be able to recognize all 4 forms
 fluently, as any of them can be used at any time. There's not really a
 style that fits all use cases.  _Trailing closure syntax_ in particular confuses people.
 We will drill you extensively on it in class, but you should
 drill yourself on it as well.
 
 ### Sequences and especially Array
 
 This function taking a function concept
 turns out to be incredibly useful when dealing with Sequence types like Array.
 It is so useful in fact that this technique completely displaces what you have
 used for-loops to do in other languages.  Note that for-loops still exist in Swift,
 but their use is never required.  If you use them, you are essentially rewriting
 boilerplate code that has already been written for you.
 
 The reason that it can do this is likely something you may never have considered: every
 for-loop that you have ever written actually follows one of a handful of patterns.
 Higher order functions on Sequence implement precisely these patterns so
 that you don't have to write the boiler plate for the pattern yourself anymore.
 The best way to think of higher order functions on Sequence is that they are each
 a specialization of a for-loop with pre-packaged boilerplate for you to use.
 
 In fact if we look at Swift's implementation of say `map`, we find that
 it is implemented as follows in a protocol extension on Sequence (code from
 the Swift 5.1.3 std lib repo):
 
 ```
 @inlinable
 public func map<T>(
   _ transform: (Element) throws -> T
 ) rethrows -> [T] {
   let initialCapacity = underestimatedCount
   var result = ContiguousArray<T>()
   result.reserveCapacity(initialCapacity)

   var iterator = self.makeIterator()

   // Add elements up to the initial capacity without
   // checking for regrowth.
   for _ in 0..<initialCapacity {
     result.append(try transform(iterator.next()!))
   }
   // Add remaining elements, if any.
   while let element = iterator.next() {
     result.append(try transform(element))
   }
   return Array(result)
 }
```
 
 i.e. map implements a for-loop which calls the transform function on each
 element of the Sequence, _no matter what kind of Sequence it is_!
 ALL of the Sequence higher order functions work this way.
 
 As an aside, if find yourself having a performance
 problem with one these implementations, you will want to look at the source
 underneath to make sure you understand its use. These implementations
 have been highly tuned in the standard lib source to take advantage of
 the underlying compiler optimizations.  (Note for example the use
 of `@inlined` here to do precisely that).  It's just
 really not possible for you to do it any faster or better by writing your own
 boilerplate.
 
 Below are the higher order patterns that are most used.  You should familiarize
 yourself with the use of ALL of the following and you should do it in the order
 we show here. (Don't worry, we're going to drill you on several of them below):
 
 The following 3 functions are easily the most important ones.
 They apply to almost ALL generic types in addition to Sequence.
 We'll talk about these in much more detail below, but you should
 pay a LOT of attention to these:
 
    map
    zip
    flatMap
 
 Sequence-specific higher order functions. You need to know these to be fluent. We'll
 play with some of them below, but you should review the documentation for any whose
 function is not clear from their name.
 
    compactMap
    reduce
    first, first(where:)
    contains, contains(where:)
    drop(while:), dropFirst(), dropLast()
    enumerated
    sorted(by:)
    joined()
    filter(where:)
    shuffled
    prefix/prefix(while)
    suffix
    allSatisfy(where:)

 For completeness we include the `forEach` which behaves as the for-loop you are familiar
 with, only it doesn't allow `break` or `continue`.
 You should never need this unless you are dealing
 with old-style imperative code that incorporates Void-returning functions.
 
    forEach

 Advanced topics:
 
    lazy
    publisher
 
 `lazy` is a sequence which does not just contain its values - it produces
 them on demand.  `publisher` is a Combine sequence which we will discuss in excruciating
 detail in a later playground.

 ### Map
 
 Here're some simple examples of the most general methods, starting with `map`.
 Map has the signature:

    Array<A>: func map <B>(_ f: (A) -> B) -> Array<B>

 That is, it is a method on `Array<A>`, that accepts as it's only argument
 a function which takes an `A` and returns a `B`.  `Map` overall returns
 an `Array<B>`.

 You use map to transform every element of an array in some way and return
 an array with exactly the same number elements, each element in the new array
 being the result of calling the transform function with the corresponding
 element of the original array.

 Here's an example.  Our transformation in this case is simply turning
 an Int into a Double representing the same value.
 */
let x0 = [1, 2, 3]
type(of: x0)
let x1 = x0.map(g)
x1
type(of: x1)
/*:
 The important point to note here is that map takes an array of one type,
 in this case `[Int]`
 and changes it to an array of the same length of another type,
 in this case `[Double]`.  `map` can produce an array of a completely
 different type than what you started with.
 
 It does this by applying a function `(A) -> B` to every element of an `[A]`
 to generate an `[B]`.
 
 If you think about it for a bit, you can see that this is a _very_ general pattern.
 Essentially every generic type `G<A>` can be converted to a `G<B>` in this manner,
 to the point that it is difficult to imagine a generic which would _not_ have a map
 function.  In fact, we will verify this below by demonstrating exactly how this
 works with the Optional type. (Recall that Optional is a generic enum of two cases).

 Here's another example this time turning [Int] to [String].
 */
let x2 = [1, 2, 3].map { "\($0)" }
x2
type(of: x2)
/*:
 Note how we go back and forth between using the parens form and the trailing closure
 syntax form.  You need to master doing this as well.
 
 ### Zip
 
 Let's look at `zip` now and think about it's general form.  Here's the
 signature of zip:

    func zip(Array<A>, Array<B>) -> Array<(A, B)>

 You use `zip` to take two arrays, match up the elements and combine
 then into one.

 In words, zip transforms a tuple of arrays into an array of tuples. Like `map`,
 `zip` is an amazingly general form that applies to almost any generic you will
 encounter, i.e. you can write a function with this signature for almost any generic G:
 
     (G<A>, G<B>) -> G<(A, B)>
 
 Again, we'll do this below for Optional but for now, we'll show how it works with Sequence.
 
 `zip` is a top level function that takes a tuple of sequences and returns a
 single sequence of tuples.  In the case of Sequence it does it in a lazy manner,
 so to we need to force the returned zip sequence into an array in order to see it easily.
 (Thats what the `Array(...)` is doing in the example).
*/
let z0 = Array(zip([1, 2, 3], ["a", "b", "c", "d"]))
z0
type(of: z0)
/*:
 Note that we do in fact have a fully realized `Array<(Int, String)>` and that further
 this array only has 3 elements.  The fourth element in the second array could not be
 matched up with an element in the first array and was therefore dropped.  To do otherwise
 we would have had to make use of Optional on either Int or String and this would have
 violated the type signature of zip.  You can certainly write a zip which pads either side,
 but the std library does not include it.
 
 ### FlatMap
 
 And finally lets look at the most general form we have `flatMap`.  Here's it's
 signature:

    Array<A>: func flatMap<B>((A) -> Array<B> ) -> Array<B>

 `flatMap` on Sequence allows us to unnest one Sequence from another.
 In this case I have [[Int]] and I want to turn it into an [Int].  If you think
 about it, like zip, you'll see that there's really only one way to implement
 this type signature.
 
 Side-note.  From here on out, you will notice that the code we write is
 largely driven
 by the type signatures.  Everything in this higher-order land we're
 exploring is about
 looking at a type signature and thinking about what we can do with
 it and what patterns
 it adheres to.  More on this below.
 
 `flatMap` on Sequence does this by simply appending each nested
 structure to a new structure
 of the same type.
 */
let fm0 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
type(of: fm0)
let fm1 = fm0.flatMap { $0 }
fm1
type(of: fm1)
/*:
 Notice that we have gone from [[Int]] to [Int] and that all of the inner array
 values have been preserved.  Again there is only one way to do this with an
 array and a function of this type signature.  Nothing else really makes sense.
 
 We can of course repeat the trick turning our [[Int]] into [String]
 */
let fm2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
type(of: fm2)
let fm3 = fm0.flatMap { "\($0)" }
fm3
type(of: fm3)
/*:
 I'm going to bet the results of that were not what you expected to see  :) Let's explain.
 
 Inside the `flatMap` we turned each `[Int]` into a `String`. So `[1, 2, 3]`
 became `"[1, 2, 3]"`, i.e. the String representation of the entire array.
 Interestingly, `String`
 conforms to the `Sequence` protocol, i.e. it is a `Sequence` of `Character`s.  Let's
 demonstrate what flatMap does to that.
 */
let s = "abc, 123, baby you and me"
let aOfs = s.flatMap { $0 }
aOfs
/*:
 So when we converted `[1, 2, 3]` to `"[1, 2, 3]"` we got something back that could
 be `flatMap`ped over and the result was produce an `Array<Character>` where each
 element of the array was a single character taken from the description string
 of an array.
 
 Here's what you were probably expecting where we turn each element of the `[[Int]]`
 into `[String]` and thereby flatten a `[[String]]`:
 */
let fm4 = fm0.map { $0.map {num in "\(num)" } }
fm4
let fm4a = fm4.flatMap { $0 }
fm4a
type(of: fm4a)
/*:
 Note the nesting of map within map that we had to do to make the individual
 translations from (Int) -> String.  You need to understand this pattern.
 
 You may ask: how many times do I have an Array<Array<A>> as my given type after all?
 That's really the wrong question.  What we're dealing with here is Sequences of which
 Array is only a particular type.  A better question is "under what circumstances am
 I likely to be dealing with a subsequence of a given sequence"?  Or: "when am I likely
 to have have to run a query against some back end that provides me as its return type
 the values I need to run a sequence of other queries?"  Or: "when will I be walking
 an array and calling a function that returns an Array on each element"
 _THOSE_ situations are when flatMap on Sequence really begins to show its power.
 
 ### Chaining
 
 All of the higher order functions on Sequence return an Array, which is itself
 a Sequence, so all of these functions can be chained together.  Below we walk
 through various transformations using chaining on Array.  It is important that
 you understand that  much of Sequence handling is in fact chaining of
 transformations based on the results of previous transformations.
 
 First let's create a few handy types and functions to use.
 */
import Foundation

func id<T>(_ t: T) -> T { t }

protocol Describable {
    var description: String { get }
}

extension String: Describable { }
extension Int: Describable { }
extension Dictionary: Describable { }
extension Array: Describable { }

protocol IntegerValuable {
    var integerValue: Int { get }
}

extension String: IntegerValuable {
    var integerValue: Int { return (self as NSString).integerValue  }
}

extension Int: IntegerValuable {
    var integerValue: Int { return self }
}
protocol IntDescribable: Describable, IntegerValuable { }

extension String: IntDescribable {}
extension Int: IntDescribable {}

struct MyInteger: Equatable, Hashable, IntDescribable, Comparable {
    static func < (lhs: MyInteger, rhs: MyInteger) -> Bool {
        lhs.integerValue < rhs.integerValue
    }

    static func intValue(_ val: IntegerValuable) -> Int {
        val.integerValue
    }

    var integerValue = 0
    var description: String { "Instance of \(type(of: self))" }
    
    init(_ withValue: Int) { integerValue = withValue }
}
/*:
 Now let's start with a Dictionary which is of course a Sequence of tuples of the form
      
     (key, value)
 
 Here we create a [String: Describable].  Just for kicks we'll use a call to `map`
 in our initialization of `d`. Note that this particular `map` invocation is picking out
 the keys of the input `Dictionary`.  We could as just have easily picked the values
 by mapping `$0.1` which would have produced `[Int]` rather than `[String]` .
 */
var smallD = [ "1": 1, "2": 2, "3": 3, "4": 4]
var d: [String: Describable] = [
    "1" : "1",
    "2" : 2,
    "3" : [1, 2, 3],
    "4" : smallD.map { $0.0 },
    "5" : [MyInteger(5)],
    "6" : ["6"]
]
type(of: d)

var m1 = d
type(of: m1)
m1
/*:
 As we go through we'll highlight each transformation with it's type signature.
 
 CompactMap acts for example on an array of optional A to produce an array of non-optional B.  We're getting an `Optional` here because we want only those elements of
 `d` which are Array<IntDescribable>, any element which does not meet that type
 will return nil.  So we are first `map`ping (Describable) -> [IntDescribable?] and
 `compact`ing by removing `.none`.  Note by the way that I refer to this as `.none`
 rather than `nil`.  This is not strictly necessary, but is a really good habit
 that you will want to get into for a number of reasons, primarily that it makes
 you _think_ about the type of `Optional` you have on hand rather than mentally
 eliding the generic parameter.
 
 ### CompactMap - [A?] -> [B]
 */
var m2 = d
    .compactMap { (_, v) in v as? [IntDescribable] }
type(of: m2)
m2
/*:
 ### FlatMap - [[A]] -> [B]
 FlatMap acts on an Array of Arrays to produce an Array
 */
var m4 = d
    .compactMap { (_, v) in v as? [IntDescribable] }
    .flatMap(id)
type(of: m4)
m4
/*:
 ### Map - [A] -> [B]
*/
var m5 = d
    .compactMap { (_, v) in v as? [IntDescribable] }
    .flatMap(id)
    .map { MyInteger($0.integerValue) }
type(of: m5)
m5
/*:
 ### Sorted - [A] -> [A]
*/
var m6 = d
    .compactMap { (_, v) in v as? [IntDescribable] }
    .flatMap(id)
    .map { MyInteger($0.integerValue) }
    .sorted(by: <)
type(of: m6)
m6
/*:
 ### Reduce - [A] -> B
 */
var m7 = d
    .compactMap { (_, v) in v as? [IntDescribable] }
    .flatMap(id)
    .map { MyInteger($0.integerValue) }
    .sorted(by: <)
    .map(MyInteger.intValue)
    .reduce(0, +)
type(of: m7)
m7
/*:
 Note that the type which falls out of all those transformations is `Int`
 
 ### Set is also a Sequence
 
 Since Set is a Sequence everything above also applies to it.
 */
var m8 = Set<MyInteger>(m6)
type(of: m8)
m8

var m9 = Set<MyInteger>(m6)
    .map { $0.integerValue }
type(of: m9)
m9

var m10 = Set<MyInteger>(m6)
    .map { $0.integerValue }
    .sorted(by: <)
type(of: m10)
m10

var m11 = Set<MyInteger>(m6)
    .map { $0.integerValue }
    .sorted(by: <)
    .reduce(1, *)
type(of: m11)
m11

/*:
 ### Higher Order Functions on Optional
 
 `map`, `zip` and `flatMap` are not just methods on Sequence.  They
 all apply to Optional as well.  You have to defocus your eyes a little
 and think about them as methods on pretty much all generic types.
 Lets discuss what that means a bit.  Here are the type signatures
 for `map` on `Array<A>` and `map` on `Optional<A>` respectively.
 
       Array<A>: func map <B>(_ f: (A) -> B) ->    Array<B> // Array
    Optional<A>: func map <B>(_ f: (A) -> B) -> Optional<B> // Optional
 
 Does the similarity stick out?   For basically ANY generic `G` (say `Array` or `Optional` since we are most familiar with those), parameterized by a type
 `A`, you can use `map` to turn that `G<A>` into a `G<B>`.
 When we get to Combine, we'll observe
 exactly the same pattern on a broader variety of generic types, btw.
 
 So let's do that with Optional.
 */
let o1 = Int?.some(4)
o1
type(of: o1)
let o2 = o1.map { "\($0)" }
o2
type(of: o2)
/*:
 Sure enough, Optional has `map` already defined on it in the std lib.  And it
 behaves in many ways like guard-let and if-let.  In fact Optional.map can frequently
 be a much more compact way of accomplishing the same thing that guard-let or if-let
 accomplish with a lot less typing.  To be fluent in Swift, you really
 need to understand
 this.
 
 The standard library doesn't include a zip for Optional, so let's
 write one using the
 form we gave above. (I'm spelling out Optional to make it more clear).
 There's not much
 choice in how we write this:
 */
func zip<A, B>(_ a: Optional<A>, _ b: Optional<B>) -> Optional<(A, B)> {
    guard let a = a, let b = b else { return Optional<(A, B)>.none }
    return Optional<(A, B)>.some((a, b))
}
/*:
 and now let's try it out again spelling everything out so that it's clear how this works.
 */
let o3 = Int?.none
let o4 = String?.none

zip(o1, o2)
type(of: zip(o1, o2))
zip(o1, o3)
type(of: zip(o1, o3))
zip(o1, o4)
type(of: zip(o1, o4))

zip(o2, o3)
type(of: zip(o2, o3))
zip(o2, o4)
type(of: zip(o2, o4))

zip(o3, o4)
type(of: zip(o3, o4))
/*:
 So our two zip functions can be thought of as having the following form:
 
         Array<A>: func zip(   Array<A>,    Array<B>) ->    Array<(A, B)>
      Optional<A>: func zip(Optional<A>, Optional<B>) -> Optional<(A, B)>
 
 Again, once you see this pattern, you see that it can apply to almost _any_ generic type.
 
 So now let's do Optional `flatMap`. Note the type of the line below.
 */
let l = 2
let o5 = o1.map { $0 / l }
o5
type(of: o5)
/*:
 Here's the problem, suppose that `l` were zero?  what should be do?  Well to prevent
 a crash we need to guard against that by returning an `Optional<Int>` rather than
 a plain ol' `Int`.  So let's do that.
 */
let o6 = o1.map { i -> Int? in
    guard l != 0 else { return nil }
    return i / l
}
o6
type(of: o6)
/*:
 Ruh-roh, Rorge. What the heck is this `Optional<Optional<Int>>` type for `o6`?
 Well it's what you get from the definition of map if `A` is `Int` and `B` is
 `Optional<Int>`. So lets look at something similar we had on Array.
 Remember the signature of `flatMap` on `Array<A>` looks like this:
 
     func flatMap<B>((A) -> Array<B> ) -> Array<B>
 
 When the transforming function returned an `Array` itself we could flatten out the
 `Array<Array<B>>` structure to form just an `Array<B>`.  And we can do the same thing with
 Optional:
 */
let o7 = o1.flatMap { i -> Int? in
    guard l != 0 else { return nil }
    return i / l
}
o7
type(of: o7)
/*:
 And here we see the reason it's called `flatMap`.  `flatMap` removes one level of
 generics, i.e. `Array<Array<A>>` becomes just `Array<A>`.  What do you think will
 happen on `Optional<Optional<A>>` if we `flatMap` it?  Yeah, it becomes just
 `Optional<A>`.
 
 Now everything looks right.  And we've demonstrated that not only do map, zip and flatMap
 work on Sequence, they also work on Optional.  And this hints that they work on
 a lot of other stuff as well.
 
 `flatMap` turns out to be one of the most powerful concepts in all of computer science and
 we will use it extensively in future playgrounds.  For now you should just note
 the pattern:
 
         Array<A>: func flatMap<B>( (A) ->    Array<B> ) ->    Array<B>
      Optional<A>: func flatMap<B>( (A) -> Optional<B> ) -> Optional<B>
 
 So finally, the question comes up. That's all well and good, but why on earth would
 I ever use this flatMap thing on Optional, it seems like a lot of typing.  And the
 answer is that you use it all the time, you just don't know it.

 Observe the following.
 */
struct C {
    var value: String = "C"
}
struct B {
    var c: C?
}
struct A {
    var b: B?
}
let a = A(b: B(c: C(value: "D")))

var d2 = a.b?.c?.value
d2
type(of: d2)
/*:
 See the value of `d2` there? well it turns out that that
 expression with the `?`'s on
 the right is just syntactic sugar for the following:
 */
let d3 = a.b.flatMap { $0.c }.flatMap { $0.value }
d3
type(of: d3)
/*:
 If you aren't seeing why that would be the case, here's the definition
 of `Optional.flatMap` from the Swift 5.1.3 Standard Library.  Try and work
 through what those invocations above would do:
 
     @inlinable
     public func flatMap<U>(
       _ transform: (Wrapped) throws -> U?
     ) rethrows -> U? {
       switch self {
       case .some(let y):
         return try transform(y)
       case .none:
         return .none
       }
     }
 
 In other words calling flatMap on Optional was so incredibly pervasive that Apple
 put special syntax in the language to save you having to type it so much.
 This is precisely the conceptual basis necessary to support ObjC interoperability
 where basically everything could return nil and Swift needed to handle the
 nil returns in a modern manner.
 */
