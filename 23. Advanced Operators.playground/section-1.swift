var andResult: UInt8 =
   0b00101111 &
   0b11110100
// 0b00100100 <- result

var notResult: UInt8 =
   ~0b11110000
//  0b00001111 <- result

var orResult: UInt8 =
   0b01010101 |
   0b11110000
// 0b11110101 <- result

var xorResult: UInt8 =
   0b01010101 ^
   0b11110000
// 0b10100101 <- result