
import Foundation


func aFunc(shouldThrow: Bool) throws -> String {
    guard !shouldThrow else {
        throw NSError(
            domain: "harvard.edu",
            code: 1,
            userInfo: ["message" : "I'm sorry"]
        )
    }
    return "Hey it worked"
}

do {
    let result = try aFunc(shouldThrow: false)
    let result2 = try? aFunc(shouldThrow: true)
    let result3 = try aFunc(shouldThrow: true)
}
catch {
    print("saw the error on the third try: \(error)")
}

enum OurError: Error {
    case firstError (String)
    case secondError (String)
    case thirdError (String)
}

func throwSpecificError(shouldThrow e: OurError?) throws -> String {
    if let e = e { throw e }
    return "Hey it worked"
}

do {
    let result4 = try throwSpecificError(shouldThrow: .firstError("this is an error of type 1"))
}
catch OurError.firstError(let message) {
    print("rethrow got: \(message)")
}
catch OurError.secondError(let message) {
    print("rethrow got: \(message)")
}
catch OurError.thirdError(let message) {
    print("rethrow got: \(message)")
}
catch {
    print("last chance: \(error)")
}

