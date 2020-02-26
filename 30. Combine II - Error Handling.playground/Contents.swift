/*:
 # Combine II - Error Handling
 
 In this playground we'll dive into Combine's ways of handling errors
 in some depth.  It turns out that Combine's error handling looks like
 a couple of things we've already seen in Optional and in Result. So
 let's explore some areas of those two things which you may not
 have considered before.
 
 ### Binary Enums

 There are two `enum`s which play a hugely important role in all
 Swift programming - `Optional` and `Result`.
 
 The general principles behind the two extend into programming with Combine.
 Let's make our own version of the two and discuss the more general mechanism that underlies them.  Then we'll talk about how Combine implements that same mechanism.
 */
enum MyOptional<T> {
    case some(T)
    case none
}
enum MyResult<T, E: Error>: CustomStringConvertible {
    case success(T)
    case failure(E)
    var description: String {
        switch self {
        case .success(let t): return "Success(\(type(of: t)): \(t))"
        case .failure(let e): return "Failure(\(type(of: e)): \(e))"
        }
    }
}
/*:
 Now let's add the usual map function to `MyOptional`.  This is precisely
 the implementation that is on the std lib `Optional`, btw:
*/
extension MyOptional {
    func map<U>(transform: (T) -> U) -> MyOptional<U> {
        switch self {
        case .some(let t): return MyOptional<U>.some(transform(t))
        case .none:        return MyOptional<U>.none
        }
    }
}
/*:
 Note: `MyOptional<U>` could be removed from the `return` statements
 above.  I put that on there to make clear that we have in fact done
 a type transformation on both the `.none` AND the `.some` branches.
 
 Now when we go to add it to MyResult we have a problem, though.
 How do we handle the extra generic type that's attached to the .failure
 case?  There are two solutions, we could add an extra parameter
 to `map` to let it take a transform on `E` as well as on `T`.  Or, we could
 write one `map` function that work on `.success` and a
 separate `mapError` function that only works on `.failure`.
 
 The answer is that we don't want to change the type signature, we want to
 add the extra method:
 */
extension MyResult {
    func map<U>(transform: (T) -> U) -> MyResult<U, E> {
        switch self {
        case .success(let t): return MyResult<U, E>.success(transform(t))
        case .failure(let e): return MyResult<U, E>.failure(e)
        }
    }

    func mapError<F>(transform: (E) -> F) -> MyResult<T, F> {
        switch self {
        case .success(let t): return MyResult<T, F>.success(t)
        case .failure(let e): return MyResult<T, F>.failure(transform(e))
        }
    }
}
/*:
 So `map` passes a `.failure` through unchanged and `mapError` passes a
 `.success` through unchanged.  This is really important, in that it allows
 you to view certain steps in a chain as skipped if they are of the
 wrong value.
 
 But we still haven't accounted for everything that could happen on MyResult.
 Suppose that the transform `(T) -> U` was actually `(T) throws -> U`.
 That's not handled in the code above.  You should be able to guess what
 we do for this.  That's right, add an extra method:
 */
extension MyResult {
    func tryMap<U>(transform: (T) throws -> U) -> MyResult<U, Error> {
        switch self {
        case .success(let t):
            do {
                return MyResult<U, Error>.success(try transform(t))
            } catch {
                return MyResult<U, Error>.failure(error)
            }

        case .failure(let e):
            return MyResult<U, Error>.failure(e as Error)
        }
    }
}
/*:
 And we need one other thing, the ability to recover from an error when one occurs
 (if such is possible).  To do that we need a method that can `catch` an error
 and convert it into a success of some sort if it can but otherwise rethrow the error.
 */
extension MyResult {
    func `catch`(transform: (E) throws -> T) -> MyResult<T, E> {
        switch self {
        case .success:
            return self
        case .failure(let e):
            do {
                return .success(try transform(e))
            } catch {
                return .failure(e)
            }
        }
    }
}
/*:
 So for practice let's do a little chaining on MyResult. The chain
 of map commands should look quite familiar by now:
 */
var finalResult = MyResult<Int, Error>.success(4) 
    .map { $0 * 2 }
    .catch { _ in 4 }
    .map { Double($0) }
    .map { "\($0)" }
finalResult

indirect enum OurError<T>: Error {
    case ourError(T)
    case ourOtherError(T, Error)
    case ourSendError(T)
}

finalResult = MyResult<Int, Error>.success(6)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .catch { _ in 4 }
    .map { Double($0) }
    .map { "\($0)" }
finalResult
type(of: finalResult)

finalResult = MyResult<Int, Error>.success(8)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .catch { _ in 4 }
    .mapError { OurError.ourOtherError("in mapError", $0) }
    .map { "\($0)" }
finalResult
type(of: finalResult)

finalResult = MyResult<Int, Error>.success(8)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .mapError { OurError.ourOtherError("in mapError", $0) }
    .catch { _ in 4 }
    .map { "\($0)" }
finalResult

type(of: finalResult)

finalResult = MyResult<Int, Error>.success(8)
    .tryMap { value throws -> Int in value * 2 }
    .mapError { OurError.ourOtherError("in mapError", $0) }
    .map { "\($0)" }
finalResult
type(of: finalResult)

finalResult = MyResult<Int, Error>.success(8)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .map { "\($0)" }
finalResult
type(of: finalResult)

/*:
 Now lets extend this to Combine. We should be able to execute the exact same things using
 a PassthruSubject<Int, OurError>:
 */
import Combine

let sub = PassthroughSubject<Int, OurError<Int>>()
var output: String = ""

var cancellable = sub
    .tryMap { value throws -> Int in
        guard value != 8 else { throw OurError<Int>.ourError(67) }
        return value * 2
    }
    .mapError { OurError.ourOtherError("in mapError", $0) }
    .catch { _ in Just(4) }
    .map { "\($0)" }
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .failure(let value): output = "Error: \(value)"
            case .finished: output = "Complete"
            }
        },
        receiveValue: {
            output = $0
        }
    )

sub.send(4)
output
sub.send(8)
output
sub.send(6)
output

sub.send(completion: .failure(OurError.ourSendError(42)))
output

/*:
 And in fact, it all looks the exactly like it did with MyResult.
 */
