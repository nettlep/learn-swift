import Foundation
import Combine

/*:
 Easy timer
 */

var timesFired = 0
var cancellable: AnyCancellable? = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .sink { time in
        timesFired += 1
        print("Fired \(timesFired) times")
    }

DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
    print("Stopping first timer")
    cancellable?.cancel()
    cancellable = .none
}


/*:
 Complicated timer
 */

var t1: Timer.TimerPublisher? = Timer.publish(every: 0.45, on: .main, in: .common)
type(of: t1)

let shared = t1?.share()
type(of: shared)

var c1Counter = 0
var c1: AnyCancellable?
c1 = shared?
    .throttle(for: 0.9, scheduler: DispatchQueue.main, latest: true)
    .sink { time in
        c1Counter += 1
        print("c1 \(c1Counter): @\(time)")
        guard c1Counter < 10 else {
            c1?.cancel()
            c1 = nil
            return
        }
    }

var c2Counter = 0
var c2: AnyCancellable?
c2 = shared?
    .throttle(for: 1.2, scheduler: DispatchQueue.main, latest: true)
    .sink { time in
        c2Counter += 1
        print("c2 \(c2Counter): @\(time)")
        guard c2Counter < 5 else {
            c2?.cancel()
            c2 = nil
            return
        }
    }

let c3 = t1?.connect()
type(of: c3)

DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
    print("Stopping second timer")
    c3?.cancel()
    t1 = nil
}

