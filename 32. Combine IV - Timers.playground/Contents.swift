import Foundation
import Combine
/*:
 # Combine IV - Timers
 
 Timers have a different set of complications from network access.
 
 In network access we were mainly concerned about the various failure modes
 and how to handle them, but the general usage pattern was quite simple,
 you fired the network request, after some period of time you received a
 result, then the request disappeared.
 
 With timers the concerns shift a bit.  Since timers are expensive in a
 performance sense, we want, as much as possible to minimize their use.
 That means that whenever we can, we'd like those parts of our code that
 are time-interrupt based to share a single timer rather than have each
 timer user make their own.
 
 So let's start with the case where we don't need to share and work
 our way forward from there.  Here is code that will start a timer
 that does not need to be shared firing.
 */
var timesFired = 0
var cancellable: AnyCancellable? = Timer
    .publish(every: 0.2, on: .main, in: .common)
    .autoconnect()
    .output(in: 0 ..< 5)
    .sink { time in
        timesFired += 1
        print("Original timer fired \(timesFired) times")
    }
/*:
 Lets dissect this piece by piece. First we get the `publisher`, telling
 the timer to fire on the main queue once per second. (`.common` has to
 do with the RunLoop modes in which the timer operates.  As you might
 suspect from the name, you almost never want to change this)
 
 Second, with the `autoconnect()` command we tell the
 publisher to start the timer whenever it gets a subscriber.
 
 Finally we subscribe with a `sink`.  Attaching a sink to the TimerPublisher
 chain will only start the timer if the chain contains an `autoconnect`, if
 you do not either `autoconnect` or subsequently say `connect` to the timer
 it will never fire.
 
 When we attach the `sink`, the timer in this case `autoconnect`s and the call
 to `sink` returns a `Cancellable`.  On the next lines, we wait 10 seconds
 and cancel the publication, which in this case will release the `publisher`
 and the underlying Timer.
 */
DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
    print("Stopping first timer")
    cancellable?.cancel()
    cancellable = .none
}
/*:
 So far so easy.  Now lets have two separate pieces of code that need
 to use the Timer.

 To do this we need to hold a separate reference to the `publisher`. We'll
 discuss why shortly, but let's go ahead and make that.
 */
var t1 = Timer.publish(every: 0.1, on: .main, in: .common)
type(of: t1)
/*:
 There are two models of things like timers that can have multiple
 listeners to their event.  Model 1 says that any subscriber cancelling
 its subscription will cause ALL subscriptions to be cancelled.
 Model 2 says that cancellation of one subscriber's subscription
 does not affect any other subscription.  It turns out that Model 1
 is the default and that if you are going to want model two, you
 have to explicitly state that you will share the publication,
 so let's get a shared publication.
 */
let shared = t1.share()
type(of: shared)
/*:
 If you notice, the timer above was set to publish at 100ms intervals.
 For purposes of this example, we want the first timer to only fire
 ever 900 ms.  So we add a `throttle` command to the shared publisher.
 NOTE that we do not `autoconnect` in this chain.
 
 We want to cut the timer off after 10 fires so we use the `output`
 publisher to send completed after that many.
 
 Also note that in the sink, we print different messages
 on completion and on timer fires.  Note that each call
 to sink produces a separate cancellable.
 */
var c1Counter = 0
var c1: AnyCancellable?
c1 = shared
    .throttle(for: 0.9, scheduler: DispatchQueue.main, latest: true)
    .output(in: 0 ..< 10)
    .sink(
        receiveCompletion: { _ in print("completed c1") },
        receiveValue: { _ in print("c1 fired") }
    )
/*:
 We want our second listener to only fire every 1.2 seconds and
 cancel after 5 throttled timer fires.
 */
var c2Counter = 0
var c2: AnyCancellable?
c2 = shared
    .throttle(for: 1.2, scheduler: DispatchQueue.main, latest: true)
    .output(in: 0 ..< 5)
    .sink(
        receiveCompletion: { _ in print("completed c2") },
        receiveValue: { _ in print("c2 fired") }
    )
/*:
 Now that we have everything set up we can start the timers firing. Note
 that we start by talking to the timer, NOT to the shared publisher.
 */
let c3 = t1.connect()
type(of: c3)
/*:
 And let's clean up before we finish and cancel our timer.
 */
DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
    print("Stopping second timer")
    c3.cancel()
}

