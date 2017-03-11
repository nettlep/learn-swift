/*:
 ## Top Level Functions
 */

/*:
 ### Stride
 */
stride(from: -11, to: 13, by: 2).forEach {
    print($0)
}
/*:
 ### Repeated
*/
let repeatedName = repeatElement("Humperdinck", count: 5)
for name in repeatedName {
    print(name)
}
/*:
### Zip
 */
let words = ["one", "two", "three", "four"]
let numbers = 1...4

for (word, number) in zip(words, numbers) {
    print("\(word): \(number)")
}
