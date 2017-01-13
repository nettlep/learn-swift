import Foundation

enum Result<T> {
    case success(() -> T)
    case failure(Error)
    
    public init(errorCode:Int, message:String)
    {
        let e = NSError(domain: "edu.harvard", code: errorCode, userInfo: ["Message" : message])
        self = .failure(e)
    }
    
    public func then<U>(_ nextOperation:@escaping (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .failure(error):       return .failure(error)
        case let .success(something):   return nextOperation(something())
        }
    }
    
    public func isFailure() -> Bool {
        switch self {
        case .failure(_): return true
        case .success(_): return false
        }
    }
    
    public func unbox() -> Any {
        switch self {
        case let .failure(error):      return error
        case let .success(something):  return something()
        }
    }
}

func start() -> Result<Void> { return .success {} }

func wait(for interval: TimeInterval, samplingAt: TimeInterval, forCondition condition: () -> Bool) -> Result<Void> {
    let end = Date(timeIntervalSinceNow: interval)
    var retVal = Result<Void>(errorCode: 2, message: "Timed out")
    var count = 0
    repeat {
        count += 1
        if condition() { retVal = .success { }; break }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: samplingAt))
    } while end.timeIntervalSinceNow > 0
    return retVal
}

func flipCoin() -> Result<Void> {
   return wait(for: 8, samplingAt: 0.2) { return arc4random_uniform(50) == 1 }
}

let result = start()
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .then { return flipCoin() }
    .unbox()
