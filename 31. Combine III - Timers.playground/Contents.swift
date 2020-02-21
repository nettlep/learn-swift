import Foundation
import Combine

let t1 = Timer.publish(every: 0.10, on: .main, in: .common)
let shared = t1.share()
type(of: t1)

var c1Counter = 0
var c1: AnyCancellable?
c1 = shared
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
c2 = shared
    .throttle(for: 1.0, scheduler: DispatchQueue.main, latest: true)
    .sink { time in
        c2Counter += 1
        print("c2 \(c2Counter): @\(time)")
        guard c2Counter < 5 else {
            c2?.cancel()
            c2 = nil
            return
        }
    }

let c3 = t1.connect()
type(of: c3)

