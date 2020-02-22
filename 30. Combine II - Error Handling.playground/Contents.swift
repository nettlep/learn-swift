/*:
 # Combine II - Error Handling
 
 ### Binary Enums

 There are two `enum`s which play a hugely important role in all
 Swift programming - `Optional` and `Result`.
 
 The general principles behind the two extend into programming with Combine.  Let's make our own
 version of the two and discuss the more general mechanism that underlies them.  Then we'll
 talk about how Combine implements that mechanism.
 */
enum MyOptional<T> {
    case some(T)
    case none
}

enum MyResult<T, E: Error> {
    case success(T)
    case failure(E)
}

enum Either<L, R> {
    case left(L)
    case right(R)
}
