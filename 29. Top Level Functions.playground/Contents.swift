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
###
 */
