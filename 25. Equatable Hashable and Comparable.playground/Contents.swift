/*:
 ## Equatable Hashable and Comparable

 Any struct which is composed only of things which are Equatable can be marked
 Equatable and will receive the default implementation.  Otherwise
 implement your own Equatable.
 
 Any struct which is composed only of things which are Hashab;e can be marked
 Hashable and will receive the default implementation.  Otherwise
 implement your own Hashable.
 */

struct EquiHashComp {
    var b: Bool
    var i: Int
    var d: Double
    var s: String
}

let e1 = EquiHashComp(b: true, i: 42, d: 3.1415926535897932, s: "Harvard.edu" )
let e2 = EquiHashComp(b: true, i: 42, d: 3.1415926535897932, s: "Harvard.edu" )
let e3 = EquiHashComp(b: true, i: 43, d: 3.1415926535897932, s: "Harvard.edu" )
let e4 = EquiHashComp(b: true, i: 43, d: 3.1415926535897932, s: "Garvard.edu" )

extension EquiHashComp: Equatable { }
e1 == e2
e1 == e3
e1 == e4

extension EquiHashComp: Hashable { }
e1.hashValue
e2.hashValue
e3.hashValue
e4.hashValue

extension EquiHashComp: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.b == rhs.b  else { return rhs.b }
        guard lhs.i == rhs.i  else { return lhs.i < rhs.i }
        guard lhs.d == rhs.d  else { return lhs.d < rhs.d }
        return lhs.s < rhs.s
    }
}

e1 < e1
e1 < e2
e1 < e3
e1 < e4


e2 < e1
e2 < e3
e2 < e4

e3 < e1
e3 < e2
e3 < e4

e4 < e1
e4 < e2
e4 < e3

