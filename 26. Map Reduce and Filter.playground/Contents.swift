import Foundation


protocol Describable {
    var description: String { get }
}

extension String: Describable { }
extension Int: Describable { }
extension Dictionary: Describable { }
extension Array: Describable { }

protocol IntegerValuable {
    var integerValue: Int { get }
}

extension String: IntegerValuable {
    var integerValue: Int { return (self as NSString).integerValue  }
}

extension NSString: IntegerValuable { }

extension Int: IntegerValuable {
    var integerValue: Int { return self }
}
protocol IntDescribable: Describable, IntegerValuable { }
extension String: IntDescribable {}
extension Int: IntDescribable {}

class IntegerClass: Hashable, IntDescribable {
    static func ==(_ lhs: IntegerClass, _ rhs: IntegerClass) -> Bool {
        return lhs.integerValue == rhs.integerValue
    }
    var integerValue = 0
    var hashValue: Int { return integerValue }
    var description: String {
        return "Instance of \(type(of: self))"
    }
    required init(_ withValue: Int) { integerValue = withValue }
}

var d: [String: Describable] = [
    "1" : "1",
    "2" : 2,
    "3" : [ 1, 2, 3],
    "4" : [ "1": 1, "2": 2, "3": 3, "4": 4].map { (k,v) in return k },
    "5" : [IntegerClass(5)],
    "6" : ["6"]
]
type(of: d)

var m1 = d
type(of: m1)
m1
    
var m2 = d
    .filter { (k,v) in return v is [IntDescribable] }
type(of: m2)
m2
    
var m3 = d
    .filter { (k,v) in return v is [IntDescribable] }
    .map { (k,v) in return v as! [IntDescribable] }
type(of: m3)
m3
    
var m4 = d
    .filter { (k,v) in return v is [IntDescribable] }
    .map { (k,v) in return v as! [IntDescribable] }
    .flatMap { $0 }
type(of: m4)
m4
    
var m5 = d
    .filter { (k,v) in return v is [IntDescribable] }
    .map { (k,v) in return v as! [IntDescribable] }
    .flatMap { $0 }
    .sorted { $0.integerValue > $1.integerValue }
type(of: m5)
m5

var m6 = d
    .filter { (k,v) in return v is [IntDescribable] }
    .map { (k,v) in return v as! [IntDescribable] }
    .flatMap { $0 }
    .sorted { $0.integerValue > $1.integerValue }
    .map { IntegerClass($0.integerValue) }
type(of: m6)
m6

var m7 = d
    .filter { (k,v) in return v is [IntDescribable] }
    .map { (k,v) in return v as! [IntDescribable] }
    .flatMap { $0 }
    .sorted { $0.integerValue > $1.integerValue }
    .map { IntegerClass($0.integerValue) }
    .reduce(0) { return $0 + $1.integerValue }
type(of: m7)
m7

var m8 = Set<IntegerClass>(m6)
type(of: m8)
m8

var m9 = Set<IntegerClass>(m6)
    .map { return $0.integerValue }
type(of: m9)
m9

var m10 = Set<IntegerClass>(m6)
    .map { return $0.integerValue }
    .sorted { $0 < $1 }
type(of: m10)
m10

var m11 = Set<IntegerClass>(m6)
    .map { return $0.integerValue }
    .sorted { $0 < $1 }
    .reduce(1) { return $0 * $1 }
type(of: m11)
m11
