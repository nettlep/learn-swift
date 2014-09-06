var someValue: Int8 = 120
var aZero: Int8 = someValue - someValue
var overflowAdd: Int8 = someValue &+ someValue
var underflowSub: Int8 = -someValue &- someValue
var overflowMul: Int8 = someValue &* someValue
var divByZero: Int8 = 100 &/ aZero
var remainderDivByZero: Int8 = 100 &% aZero