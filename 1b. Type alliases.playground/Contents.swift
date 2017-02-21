/*:
 ## Type Aliases
 
 Type Aliases allow you to provide a different name for types, similar to 'typedef' in C.
 Here we create an alias for UInt16 called "AudioSample"
 */
typealias AudioSample = UInt16
/*:
  This actually calls UInt16.min
*/
var maxAmplituedFound = AudioSample.min
/*:
 Type aliases can be declared on our own types, in this case MySimpleStruct
 
 (Don't worry for now about what a stuct is, that's coming.
*/
struct MySimpleStruct {
	static let a = 99
}
typealias MyAliasedName = MySimpleStruct
MyAliasedName.a

