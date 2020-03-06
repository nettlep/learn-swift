/*:
 # Combine I - The Basics
 
 Combine combines (pun intended) two concepts we've already seen:
 function composition and higher order functions on Sequences.
 
 First, let's pull in the Combine package (why this is not part of the
 std lib at this point is beyond me).
 */
import Combine
/*:
 ### Synchronous Sequences
 
 Now let's start with a simple use of higher order functions on a Sequence.
 The idea is that we'll do some operations on a plain ordinary Sequence
 like an `Array` and show that the exact same operations can
 be performed using Combine Publishers and Subscribers.

 In this case the Sequence is `[Int]` and we'll stick with `map` for
 simplicity of explication.  (And yes I know that all 3 map lines below
 could be more efficiently turned into a single map.  If you like and
 this bothers you, feel free to make the first one do something like
 return an optional, the second one then becomes compactMap and the
 third one be a reduce. Like I said, we're doing map to make the example
 simple).
 */
let r1 = [1, 2, 3]      // Array<Int>
    .map { $0 * 2 }     // Array<Int>
    .map { Double($0) } // Array<Double>
    .map { "\($0)" }    // Array<String>
r1
/*:
 This behaves in the way that we've become accustomed to:
 each of the 4 lines returns an Array. The first two lines return `[Int]`,
 the 3rd line returns `[Double]` and the 4th line returns `[String]`.
 
 Importantly, each line operates on a  batch - it processes
 its entire input array to produce an output array which is chained
 to the next call.  None of the elements of any of the arrays can
 get ahead of each other - they pass through the machinations of
 the chain as a group. (If necessary, go back to Playground 27.
 Higher Order Functions I and review the Swift Std Lib code
 for map to see why this might be).
 
 If you think about it though, **_there's no reason to do this in a batch_**.
 Map _could_ take each argument that it is passed, do its thing,
 and pass it to the next function immediately rather than waiting
 for the whole batch to be complete before going to the next step.
 
 Reread that last paragraph. Because *_THAT_* is what Combine does.
 That is _all_ Combine does. Nothing more, nothing less.
 
 Seriously, that's all it does, it lets you drop values in one
 at a time at the top of one of these chains (aka publish the value),
 then it transforms the values
 through the chain, and then you get the resulting value out at the
 bottom of the chain (aka subscribe).
 If you truly understand that operation, and all
 the transformations that make sense in between, then you understand
 Combine.
 
 Of course we need to account for a few extra things when doing that.
 Here's the list of what you need:
 
 1. *A Publisher type*.
 The calls to map can't return arrays,
 they have to return some other
 type that knows how to do some processing and pass the result to the
 next thing in the chain.  We call these things Publishers.  (More generally
 as we discussed previously with Optional, you should train yourself
 not to see Array or Publisher in chains like the one above.  You should
 see "SomeGenericThing").
 
 2. *A Completion value*.
 We need some way to know that we're done.  Array can
 know when it's done because it knows the `count` of the
 array when we call map. It does that many things and then stops.
 If a Publisher is just responding to it's input one at time, it never knows
 when processing is complete and it can clean up and go away.
 
 3. *Error handling*.
 We need someway to handle errors. There aren't many choices here,
 you sort of have to pass the error down the chain.  We just need
 to figure out how to make that happen.
 
 4. *A Subscriber type*.
 Something needs to sit at the end of the chain and process the things
 coming out one at a time.  In the example above, we want something at the end
 of the chain which can construct the equivalent of `r1` by accepting
 the values one at a time in a stream. We call this thing
 a Subscriber.  A Subscriber sits at the end of every Publisher chain.  if
 there is not a Subscriber, the Publisher is not allowed to publish.  In fact,
 in Combine, unlike other FRP packages, the subscriber tells the publisher
 _how many_ items it is allowed to publish. (This feature is called `backpressure`).
 
 5. *Cancellability*.
 For long running Sequences, we'd like the opportunity to cancel the
 publication before it sends the "hey, I'm complete" message.
 
 Once you really absorb these differences, the rest is simply detail on
 how each type of Publisher works (Map, FlatMap, Filter, etc all
 return different _types_ of publisher, which is not the case with
 the operations on Array).
 
 ### Functional Comoposition in Combine
 
 So where does functional composition come in?  The best way to
 understand it is to try and write a mini version of Combine yourself.
 This lets you gain a lot of intuition about why Combine does things
 the way it does. While this is a great exercise and I recommend it to
 all who are serious about Swift programming, I'll go ahead and tell
 you the answer.
 
 See all those `map` statements? What each one actually does is
 to `compose` a function by combining a) the closure argument attached
 to it with b) a function presented to it by its downstream successor Publisher.
 It then presents the function it composed upstream to its predecessor.

 At the top of the chain publishing a new value simply consists of
 calling the function you received from your immediate neighbor downstream.
 
 Read that paragraph again, too.  We did not talk about functional
 composition in the previous playground just for fun.
 I mean, it was fun, but this notion of functional composition
 that we built up there is used not only by the Swift language
 itself, it's used everywhere, starting with Combine. What we've
 done here is move to a higher level where we are doing more than
 just one composition at a time, we're doing an entire chain
 of compositions recursively.
 
 That composition proceeds backwards up the chain
 from bottom to top, but... (and this is important),
 it happens _only when we subscribe_.
 It is really important to note
 that the composition does not occur until you attach a subscriber
 at the end.  Until that point, you can think of the publishers
 as being a sort of freeze-dried process that is ready to
 be composed as soon as it is immersed in the water of a subscriber.
 This is what I meant in the previous playground
 about Combine being a package of functions for composing functions that
 compose functions.
 
 You can just try to understand Combine holistically,
 but if you don't want it to ever be able to fool you, you need to be
 able to construct all of the composition that is going on here.
 
 Functional composition in action. Learn it, love it, live it.
 
 And "Look, Ma!" with just those changes, we've gotten rid of doing `map`
 etc just on arrays. Remember when we pointed out that `map` can apply
 to almost any generic?  Well here's another generic (i.e. Publisher) and
 in fact, `map` applies to it. And if you look, it also responds to `zip`
 and `flatMap`
 
 ### Using Combine
 
 Ok, so let's translate our example to Combine.  We'll start by creating a value to hold our output.
 */
var r2: [String] = []
/*:
 Now we'll do the same example the Combine way. Here's the example from before
 for you to refer to:
 
     let r1 = [1, 2, 3]      // Array<Int>
         .map { $0 * 2 }     // Array<Int>
         .map { Double($0) } // Array<Double>
         .map { "\($0)" }    // Array<String>
     r1
 
 Feel free to scroll back up and verify
 that all of the pieces from the previous example are still there.
 
 Here's the _exact_ same thing only done in Combine.  Note how we still
 have the same array to start and the same `map` statements, but we've
 added two new lines.
 */
let c1 = [1, 2, 3]
    .publisher
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
    .sink { r2.append($0) }
/*:
 When we look at `r2` we see its contents are exactly the same as we had before in `r1`
 */
r1
r2
/*:
 So what are those `publisher` and `sink` lines in there?  Well,
 they are us meeting two of the requirements above.
 
 Combine actually includes the ability to turn an Array into a Publisher.
 It adds an extension to Array that includes
 `var publisher`. That publisher takes the contents of the array and invokes
 the downstream function with
 each element of the array sequentially, as the subscriber allows.
 The publisher returned from
 `[1, 2, 3].publisher` is the type that meets Requirement 1 (a Publisher type) above.
 
 In this case we are using a Subscriber that tells the publisher upstream
 that it can take an unlimited number of values.
 That's what the `sink` is on the end - a function which creates a
 Subscriber using a closure to process the
 received values.  That meets Requirement 4 (a Subscriber type) above.
 
 And that's it!  Pretty much all of Combine is "just" variations on this theme.
 But we're not stopping there.
 As always, types are important.  First look at the type of `c1`.
 */
type(of: c1)
/*:
 `c1` turns out the be an  AnyCancellable.  We'll discuss the `Any`
 part later, but `c1` is exactly the type we need to satisfy Requirement
 5 (Cancellability) above. In this case everything is done before we could have a chance to
 cancel it, but shortly we'll see where we _can_ actually cancel things.
 
 So 3 requirements down, two to go.  Now lets look at what we get from the middle of the chain (annotating the return types.:
 */
let p1 = [1, 2, 3]       // Array<Int>
    .publisher           // Publishers.Sequence<[Int], Never>
    .map { $0 * 2 }      // Publishers.Sequence<[Int], Never>
    .map { Double($0) }  // Publishers.Sequence<[Double], Never>
    .map { "\($0)" }     // Publishers.Sequence<[String], Never>
type(of: p1)
/*:
 Now this starts to look interesting.  Seems like a Publishers.Sequence is a
 generic type that is parameterized by
 `[String]` and `Never`.  What  `Never` represents is a very interesting
 topic that we'll pick up later.
 But for now we'll note that the first parameter is the type of the
 value being published and the second one
 is the type of the Error that can occur. Apparently we can expect
 this publisher to never error. (Hence the name of
 the type).
 
 Also note that the return types have changed.  Instead of returning a type
 of Array we are returning a corresponding Publisher type.  Remember that Array
 is a generic type and _must_ be parameterized by some other type.  Well
 the same is true of Publishers, only they are parameterized by two types instead
 of just one, where the second type is the kind of Error type that the Publisher
 can propogate downstream.
 
 A big difference between an `Array` and a `Publisher` though is in those
 type parameters.  `Array` only has one: the `Element` type of the array.
 `Publisher` has _two_: the same `Element` type and another type representing
 the errors that can be thrown by this `Publisher`.  Why `Publisher` needs
 an error type, but `Array` doesn't will be discussed in detail in the next
 playground, but for now, just note that in Combine, errors are passed down
 the publication chain, but that for `Array`, they are thrown up the
 call stack.  `Array` doesn't need to specify its error type, because
 it expects you to deal with whatever type it chooses to throw.
 
 So it turns out that each of those calls subsequent to `[1, 2, 3].publisher`
 returns a new publisher which
 is initialized with its predecessor.  The initialization with the predecessor
 is really important.
 What's going to happen is at some point the publisher will be provided with a
 subscription closure by its
 successor type. When that happens it will compose the subscription closure
 with it's own closure
 and provide the composed function to its predecessor as the predecessor's
 subscription function.
 i.e. we are building up the function associated with the chain by using
 ta-dah, _functional
 composition_.
 
 Feel free to read that paragraph again, too.  I'll wait.
 
 And just for completeness we see that we get an AnyCancellable back here as well. And that everything works like before.
 */
let c1a = p1.sink { r2.append($0) }
type(of: c1a)
r2
/*:
 ### Function Composition and Capture Semantics
 
 The key concept to to really understand about
 what's happening here is this:  As soon as
 we attach the subscriber, the functional composition happens and all the the pieces
 below we used to build up our chain disappear from our sight forever.
 
 At the line:
 
     let c1a = p1.sink { r2.append($0) }
 
 the composition happens. The thing at the top of the chain
 is presented with a function which implements the chain and an
 AnyCancellable is constructed.  All of the functions that we used
 to build up the chain are captured into that single function where we
 can never see them again. If you need to review that, go back to the previous
 playground (Higher Order Functions 2) and look for the word capture.
 
 This means it is pretty important that you understand the capture
 semantics for closures.  Because every time you attach a Subscriber
 to a Publisher chain, capture occurs and any references are
 captured into the publication function to be used for the life
 of the function.  This is what I meant about why you need to understand
 what Combine is doing underneath in order to never be fooled by it.
 
 Ok, so at this point we're only missing
 Requirements 2 (Completion value) and 3 (Error handling)
 above, and we'll deal with those shortly.  But first let's ask,
 what's the point of all this?
 
 ## Asynchronous Sequences
 
 I mean, it's all great that we can replace the functions on Array with publishers and avoid
 creating the intermediate arrays. But this seems pretty esoteric, what's the big deal?
 In a single word, the big deal is ASYNCHRONY.
 
 This technique allows us to invoke our chain of transformations of our input asynchronously.
 So lets do that the simplest way that Combine allows by using the same example we've been
 working on.

 As before we create an array to hold the output.
 */
var r3: [String] = []
/*:
 And again, here are our previous examples:
 
     let r1 = [1, 2, 3]      // Array<Int>
         .map { $0 * 2 }     // Array<Int>
         .map { Double($0) } // Array<Double>
         .map { "\($0)" }    // Array<String>
     r1
 
 And
 
     let c1 = [1, 2, 3]
        .publisher
        .map { $0 * 2 }
        .map { Double($0) }
        .map { "\($0)" }
        .sink { r2.append($0) }

 But now instead of using `[Int].publisher`
 we use a new kind of Publisher, a `PassThroughSubject`.
 Notice how this code looks a lot like `[Int].publisher`
 except that for some reason, we have put `sub1` in
 a variable.
 */
let sub1 = PassthroughSubject<Int, Never>()
let c2 = sub1
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
    .sink { r3.append($0) }
type(of: c2)
r3
struct Void { }
let v = Void()
type(of: v)
enum Foo { }
/*:
 Now this is different.  Before, when we connected the `sink` all the values
 in the array were sent through immediately and our results array was populated.
 But now, `r3` has nothing in it.
 
 This time, unlike both the examples above, our root publisher
 doesn't send all the values down the chain immediately.  In fact, we haven't
 even given the root publisher (the PassthroughSubject) any values to send.
 
 So you can probably guess what we do now.  Yeah, we start sending the values
 in one at a time.  Note the value of r3 after each send.
 Also note that the thing which responds to `send` is the `PassThroughSubject`, not
 any of the intervening `Publisher`s.  That's why we had to keep the subject in
 a separate variable, so that we could later call `send` on it.
 */
r3
sub1.send(1)
r3
sub1.send(2)
r3
sub1.send(3)
r3
/*:
 And now we see why we held `sub1` out separately, we needed
 to keep the reference so we could call `send` on it.
 
 And now after sending the same three values we've been sending we have
 exactly the same results as before, but we have sent the values into the
 PassThrough subject **_ASYNCHRONOUSLY_**.
 In fact, we could have programmed random delays into the sequence above,
 just to illustrate the asynchronous nature of what we are doing.
 
 Now finally we decide we've sent everything that needs to be sent, and we notify
 the PassThroughSubject that there will be no more values coming down the pipe:
 */
sub1.send(completion: .finished)
r3
/*:
 And _that_ is how we deal with Requirement 2 (Completion) above.
 We didn't have to do this with
 the Array publisher before, because that particular publisher sends the completion
 down the pipe itself.  With PassThroughSubject, we have to do it ourselves.
 
 And now note that if we try to send values through the chain, nothing happens,
 because the Sequence has already been completed.
 */
sub1.send(4)
r3
/*:
So if you go and look at the Apple doc on PassThroughSubject,
 you will find the following:
 
 ```
 As a concrete implementation of Subject, the PassthroughSubject provides a convenient way to adapt existing imperative code to the Combine model.
 
 Unlike CurrentValueSubject, a PassthroughSubject doesn’t have an initial value or a buffer of the most recently-published element. A PassthroughSubject drops values if there are no subscribers, or its current demand is zero.
 ```
 This is way we can interface our existing imperative code to the functional world
 in Combine.  When our imperative code generates
 some new value we want to publish, we drop it into a PassThroughSubject and *boom!*
 out it comes the other end of the chain.
 
 Btw, if you are familiar with UIKit programming, this will remind you of something.
 It's a lot like a NotificationCenter, only everything that goes through it is
 explicitly typed and you can do this chaining action on things _before_ you
 receive the notification.
 
 Among other things, Combine replaces NSNotification and NSNotificationCenter with
 a much more flexible mechanism which can garbage collect far more readily and which
 does not steer you into using one gigantic singleton of NotificationCenter.
 
 One more important thing to note about PassThroughSubject that lets
 you know it still has one foot in the imperative
 world - it's a `class` (aka a reference type) _unlike most Publishers_
 which are `struct`'s (aka value types).  Why is this important?  Well, mainly it means
 that you can reference the _same_ PassThroughSubject in multiple places
 in your code and that any publisher chain which
 you attach to that same instance will also get it's `sink` eventually invoked when you say send.
 
 So let's try that out quickly.  First as usual create structures to hold our output.
 */
var r4: [String] = []
var r5: [Double] = []
/*:
 Now let's create a new subject:
 */
let sub2 = PassthroughSubject<Int, Never>()
/*:
 And this time, lets tie TWO chains to the same subject. Note that they do different things.  One makes Strings from the Int that gets input, the other makes Doubles.
 */
let c3 = sub2
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
    .sink { r4.append($0) }

let c4 = sub2
    .map { $0 * 2 }
    .map { Double($0) }
    .sink { r5.append($0) }
/*:
 So, as before we send some values down the pipe.
 */
sub2.send(1)
sub2.send(2)
sub2.send(3)

/*:
 Now... Lets cancel the second chain.
 */
c4.cancel()
sub2.send(4)
/*:
 So what do you expect the values of r4 and r5 to be?
*/
r4
r5
/*:
 If you expected r4 to have 4 values and r5 to have only 3, you got it right.

 ### Conclusion
 
 Let's make explicit some things that should be jumping out at you at
 this point, but that we have not discussed:
 
 1. Sequence and Publisher have almost _exactly_ the same set of methods
 defined on them.  For every higher order function that you are used to
 working with on Sequence, you expect to find the exact same function
 defined on Publisher.  This is not coincidental.  They both model
 the common notion of "sequence", one synchronously, one asynchronously.
 2. The only cases where Sequence and Publisher differ in their method
 signature are places that are clearly related to things being synchronous
 vs asynchronous.  For example `Publisher` doesn't have a `makeIterator` function
 and Sequence doesn't have a `collect(byTime:)` function.
 3. Combine does to "callback" functions precisely what the higher-order
 functions on `Array` do to for-loops, it takes away all the boilerplate
 and gives you specializations of callbacks in the form of higher-order
 functions.  Just like you don't need for-loops anymore, with Combine
 you no longer need callback functions.  Seriously.
 
 Given that last one, we see that we have a marker that allows
 us to go through our current code base and say: "replace with
 Combine" - i.e. we should fix any place where we are using
 callbacks.  And that includes any use of delegation protocols,
 as well as the more direct `completionHandler` patterns.
 
 There are three places that should immediately spring
 out at you as being ripe for this:
 
 1. Doing network access - if we could have our webservice calls just pop
 the returned values into a Publisher
 we would never have to write loads of nested callback code again.
 2. Responding to timers - we could attach listeners to our timers
 as above with PassThroughSubject and process timer firing in the same
 way we process network events.
 3. UI event handling.  If we could model touches and other UI interaction
 as _events_ then we could tie these
 chains to our UI and process the stream of user interactions
 that way, rather than using the traditional UIKit callback method
 of `delegation`.
 
 We'll defer the third one until we talk about SwiftUI, but suffice
 it to say that if we cover network access, timers and GUI events, we will have
 radically overhauled the way we architect iOS apps.  In fact, the
 architectural change will be so radical as to be disorienting at times.

 Finally, for this playground, lets talk about how we manage dispatch
 onto different queues.  Here it is:
 */
import Dispatch
import Foundation
var queue = OperationQueue()
var r6 = [String]()
let sub3 = PassthroughSubject<Int, Never>()
let c5 = [1, 2, 3, 4, 5, 6, 7].publisher
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
    .subscribe(on: queue)
    .receive(on: DispatchQueue.main)
    .sink { r6.append($0) }
type(of: c5)
r6
/*:
 This demonstrates us taking any heavy calculations we need to
 do onto a background thread and then once its done bringing
 it back on the main thread.  Asynchrony in action...

 There're two more things we need to talk about before we get to Networking, though:
 
 1. Exactly _how_ combine does what it does (aka functional composition)
 2. Requirement 3 (Error handling).
 
 In the next playground we'll explain more about higher order functions,
 specifically functions that in addition to accepting other functions
 as arguments, provide new functions as return values.
*/

