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

// Keep trying the condition for a certain amount of time, sampling at a given interval
// When the condition succeeds return with Result.success, otherwise Result.failure
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


// wait for one sample in 50 to = 1
func patientlySampleDistribution(_ numberOfTimes: Int) -> Result<Void> {
   return wait(for: Double(numberOfTimes) * 0.2, samplingAt: 0.2) { return arc4random_uniform(50) == 1 }
}

// Chain a set of asynchronous steps.  Drop out of the chain at the first failure
let result = start()
    .then { return patientlySampleDistribution(50)  }
    .then { return patientlySampleDistribution(100) }
    .then { return patientlySampleDistribution(20)  }
    .then { return patientlySampleDistribution(30)  }
    .then { return patientlySampleDistribution(40)  }
    .then { return patientlySampleDistribution(50)  }
    .then { return patientlySampleDistribution(60)  }
    .then { return patientlySampleDistribution(70)  }
    .unbox()
