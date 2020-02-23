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
                let u = try transform(t)
                return MyResult<U, Error>.success(u)
            } catch {
                return MyResult<U, Error>.failure(error)
            }

        case .failure(let e):
            return MyResult<U, Error>.failure(e as Error)
        }
    }
}
/*:
 So for practice let's do a little chaining on MyResult. The chain
 of map commands should look quite familiar by now:
 */
var finalResult = MyResult<Int, Error>.success(4) 
    .map { $0 * 2 }
    .map { Double($0) }
    .map { "\($0)" }
finalResult

indirect enum OurError<T>: Error {
    case ourError(T)
    case ourOtherError(T, Error)
}

finalResult = MyResult<Int, Error>.success(6)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .map { Double($0) }
    .map { "\($0)" }
finalResult
type(of: finalResult)

finalResult = MyResult<Int, Error>.success(8)
    .tryMap { value throws -> Int in throw OurError.ourError(value) }
    .mapError { OurError.ourOtherError("in mapError", $0) }
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
 Now lets extend this to Combine.
 We should be able to execute the exact same things using
 a PassthruSubject<Int, OurError>:
 */
