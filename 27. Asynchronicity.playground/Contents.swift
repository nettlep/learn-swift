import Foundation


// The result class is for chaining asynchronous calls together with each returning 
// success or failure.  Note the use of two generic types
enum Result<T> {
    case success(() -> T)
    case failure(Error)
    
    init(errorCode:Int, message:String) {
        let e = NSError(domain: "edu.harvard", code: errorCode, userInfo: ["Message" : message])
        self = .failure(e)
    }
    
    func then<U>(_ nextOperation:@escaping (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .failure(error):       return .failure(error)
        case let .success(something):   return nextOperation(something())
        }
    }
    
    var isFailure: Bool {
        switch self {
        case .failure(_): return true
        case .success(_): return false
        }
    }
    
    func unbox() -> Any {
        switch self {
        case let .failure(error):      return error
        case let .success(something):  return something()
        }
    }
}

func start<T>(_ value: T) -> Result<T> { return .success { value } }

// Keep trying the condition for a certain amount of time, sampling at a given interval
// When the condition succeeds return with Result.success, otherwise Result.failure
func wait(for interval: TimeInterval, samplingAt: TimeInterval, forCondition condition: () -> Bool) -> Result<Int> {
    let end = Date(timeIntervalSinceNow: interval)
    var retVal = Result<Int>(errorCode: 2, message: "Timed out")
    var count = 0
    repeat {
        count += 1
        if condition() { retVal = .success { return count }; break }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: samplingAt))
    } while end.timeIntervalSinceNow > 0
    return retVal
}

// wait for one sample in 50 to = 1
func patientlySampleDistribution(_ numberOfTimes: Int) -> Result<Int> {
    let interval = 0.25
    return wait(for: Double(numberOfTimes) * interval, samplingAt: interval) {
        return arc4random_uniform(50) == 1
    }
}

// Chain a set of asynchronous steps.  Drop out of the chain at the first failure
// Take a look at http://promisekit.org
let result = start("at start")
    .then { result -> Result<Int> in print("\(result)"); return patientlySampleDistribution(50)  }
    .then { result -> Result<Int> in print("1 ran \(result) times"); return patientlySampleDistribution(100) }
    .then { result -> Result<Int> in print("2 ran \(result) times"); return patientlySampleDistribution(20)  }
    .then { result -> Result<Int> in print("3 ran \(result) times"); return patientlySampleDistribution(30)  }
    .then { result -> Result<Int> in print("4 ran \(result) times"); return patientlySampleDistribution(40)  }
    .then { result -> Result<Int> in print("5 ran \(result) times"); return patientlySampleDistribution(50)  }
    .then { result -> Result<Int> in print("6 ran \(result) times"); return patientlySampleDistribution(60)  }
    .then { result -> Result<Int> in print("7 ran \(result) times"); return patientlySampleDistribution(70)  }
    
result.unbox()
