/*:
 # Combine I - The Basics
 
 Combine combines (pun intended) two concepts we've already seen:
 function composition and higher order functions on Sequences.
 
 First, let's pull in the Combine package (why this is not part of the
 std lib at this point is beyond me).
 */
import Combine
/*:
 Now let's take a simple use of higher order functions on a Sequence.
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
 Each line operates on a  batch, it processes its entire input array to
 produce an output array which is chained to the next call.
 
 If you think about it though, there's no reason to do this in a batch.
 Map _could_ take each argument that it is passed, do its thing,
 and pass it to the next function immediately rather than waiting
 for the whole batch to be complete before going to the next step.
 
 Reread that last paragraph.  *_THAT_* is what Combine does.
 Nothing more, nothing less.
 
 Seriously, that's all it does, it lets you drop values in one
 at a time at the top of a chain (aka publish), transform them
 through the chain, and then get the resulting value out at the
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
 We need some way to know that we're done.  Array knows it's done
 because it knows the `count` of the array when we call map.
 It does that many things and then stops.
 If a Publisher is just responding to it's input one at time, it never knows
 when processing is complete and it can clean up and go away.
 
 3. *Error handling*.
 We need someway to handle errors. There aren't many choices here,
 you sort of have to pass the error down the chain.
 
 4. *A Subscriber type*.
 Something needs to sit at the end of the chain and process the things
 coming out one at a time.  In the example we want something at the end
 of the chain which can construct the equivalent of `r1`. We call this thing
 a Subscriber.  A Subscriber sits at the end of every Publisher chain.  if
 there is not a Subscriber, the Publisher is not allowed to publish.  In fact,
 in Combine, unlike other FRP packages, the subscriber tells the publisher
 _how many_ items it is allowed to publish. (This feature is called `backpressure`).
 
 5. *Cancelability*.
 For long running Sequences, we'd like the opportunity to cancel the
 publication before it sends the "hey, I'm complete" message.
 
 Once you really absorb these differences, the rest is simply detail on
 how each type of Publisher works (Map, FlatMap, Filter, etc all
 return different _types_ of publisher, which is not the case with
 the operations on Array).
 
 So where does functional composition come in?  The best way to
 understand it is to try and write a mini version of Combine yourself.
 This lets you gain a lot of intuition about why Combine does things
 the way it does. While this is a great exercise and I recommend it to
 all who are serious about Swift programming, I'll go ahead and tell
 you the answer.
 
 See all those `map` statements? What each one actually does is
 to `compose` a function by combining a) the closure argument attached
 to it and b) a function presented
 to it by its downstream counterpart.  It then presents the composed
 function to its upstream parent.  At the top of the chain publishing a
 new value simply consists of calling the function you received from
 your immediate neighbor downstream.
 
 Read that paragraph again, too.  We did not talk about functional
 composition in the previous playground just for fun.  What we've
 done here is move to a higher level where we are doing more than
 just one composition, we're doing an entire chain of composition
 recursively.
 
 That composition proceeds backwards up the chain
 from bottom to top _but only when we subscribe_.  It is really important to note
 that the composition does occur until you attach a subscriber
 at the end.  Until that point, you can think of the publishers
 as being a sort of freeze-dried composition that is ready to
 be composed as soon as it is immersed in the water of a subscriber.
 This is what I meant previously about Combine being a package
 for composing functions that compose functions.
 
 You can just try to understand Combine holistically,
 but if you don't want it to ever be able to fool you, you need to be
 able to construct all of the composition that is going on here.
 
 Functional composition in action. Learn it, love it, live it.
 
 And "Look, Ma!" with just those changes, we've gotten rid of doing `map`
 etc just on arrays. Remember when we pointed out that `map` can apply
 to almost any generic?  Well here's another generic (i.e. Publisher) and
 in fact, `map` applies to it. And if you look, it also responds to `zip`
 and `flatMap`
 
 Ok, so let's translate our example to Combine.  We'll start by creating a value to hold our output.
 */
var r2: [String] = []
/*:
 Now we'll do the same example the Combine way.  Feel free to scroll back up and verify
 that all of the pieces from the previous example are still there.
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
r2
/*:
 So what are those `publisher` and `sink` lines in there?
 
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
 5 (Cancelability) above. In this case everything is done before we could have a chance to
 cancel it, but shortly we'll see where we _can_ actually cancel things.
 
 Now lets look at what we get from the middle of the chain (annotating the return types.:
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
 At this point we're only missing Requirements 2 (Completion value) and 3 (Error handling)
 above, and we'll deal with those shortly.  But first let's ask,
 what's the point of all this?
 
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
 But now instead of using `[Int].publisher`
 we use a new kind of Publisher, a `PassThruSubject`.  Notice how this code looks exactly
 like the `[Int].publisher`
 */
let sub1 = PassthroughSubject<Int, Never>()
let c2 = sub1
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
    .sink { r3.append($0) }
type(of: c2)
/*:
 This time however, unlike both the examples above, we don't send all the values
 immediately, we send them one at a time.  Note the value of r3 after each send.
 Also note that the thing which responds to `send` is the PassthruSubject, not
 any of the intervening Publishers.  That's why we had to keep the subject in
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
 And now after sending the same three values we've been sending we have the
 same results as before, but we have sent the values into the
 Passthru subject asynchronously.
 In fact, we could have programmed random delays into the sequence above,
 just to illustrate the asynchronous nature of what we are doing.
 
 But finally we decide we've sent everything that needs to be sent, and we notify
 the PassthruSubject that there will be no more values coming down the pipe:
 */
sub1.send(completion: .finished)
r3
/*:
 And _that_ is how we deal with requirement 2 above.  We didn't have to do this with
 the Array publisher before, because that particular publisher sends the completion
 down the pipe itself.  With PassthruSubject, we have to do it ourselves.
 
 And now note that if we try to send values through the chain, nothing happens,
 because the Sequence has already been completed.
 */
sub1.send(4)
r3
/*:
So if you go and look at the Apple doc on PassthruSubject,
 you will find the following:
 
 ```
 As a concrete implementation of Subject, the PassthroughSubject provides a convenient way to adapt existing imperative code to the Combine model.
 
 Unlike CurrentValueSubject, a PassthroughSubject doesn’t have an initial value or a buffer of the most recently-published element. A PassthroughSubject drops values if there are no subscribers, or its current demand is zero.
 ```
 So this is way we can interface our existing imperative code to the functional world.
 When our imperative code generates
 some new value we want to publish, we drop it into a PassthruSubject and *boom!*
 out it comes the other end of the chain.
 
 One more important thing to note about PassthruSubject that lets
 you know it still has one foot in the imperative
 world - it's a `class` (aka a reference type) _unlike most Publishers_
 which are `struct`'s (aka value types).  Why is this important?  Well, mainly it means
 that you can reference the _same_ PassthruSubject in multiple places
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
 
 So there are three places that this technique should immediately spring
 out at you as being useful:
 
 1. Doing network access - if we could have our webservice calls just pop
 the returned values into a Publisher
 we would never have to write loads of nested callback code again.
 2. Responding to timers - we could attach listeners to our timers
 as above with PassthruSubject and process timer firing in the same
 way we process network events.
 3. Touch handling.  If we could model touches and other UI interaction
 as _events_ then we could tie these
 chains to our UI and process the stream of user interactions
 that way, rather than using the traditional UIKit callback method
 of `delegation`.
 
 We'll defer the third ones for now until we talk about SwiftUI, but suffice
 it to say that if we cover network access, timers and GUI events, we will have
 radically overhauled the way we architect iOS apps.  In fact, the
 architectural change will be so radical as to be disorienting at times.
 
 There's one more thing we need to talk about before we get to Networking, though,
 - Error handling.  Networks are things that fail and somehow we need to deal with
 failure.
 
 In the next playground we'll explain how we meet Requirement 3 (Error handling)
 in Combine.
*/
