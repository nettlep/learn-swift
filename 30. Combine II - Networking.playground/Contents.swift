/*:
 Chris Latner and Joe Groff wrote the following in the
 [Swift Concurrency Manifesto](https://gist.github.com/lattner/31ed37682ef1576b16bca1432ea9f782).
 It bears repeating at length:
 
 ====================================

 *Asynchronous APIs are difficult to work with*

 Modern Cocoa development involves a lot of asynchronous programming using
 closures and completion handlers, but these APIs are hard to use. This gets
 particularly problematic when many asynchronous operations are used, error
 handling is required, or control flow between asynchronous calls is non-trivial.

 There are many problems in this space, including the "pyramid of doom" that
 frequently occurs:

 ```
 func processImageData1(completionBlock: (result: Image) -> Void) {
     loadWebResource("dataprofile.txt") { dataResource in
         loadWebResource("imagedata.dat") { imageResource in
             decodeImage(dataResource, imageResource) { imageTmp in
                 dewarpAndCleanupImage(imageTmp) { imageResult in
                     completionBlock(imageResult)
                 }
             }
         }
     }
 }
 ```
 Error handling is particularly ugly, because Swift's natural error
 handling mechanism cannot be used. You end up with code like this:
 ```
 func processImageData2(completionBlock: (result: Image?, error: Error?) -> Void) {
     loadWebResource("dataprofile.txt") { dataResource, error in
         guard let dataResource = dataResource else {
             completionBlock(nil, error)
             return
         }
         loadWebResource("imagedata.dat") { imageResource, error in
             guard let imageResource = imageResource else {
                 completionBlock(nil, error)
                 return
             }
             decodeImage(dataResource, imageResource) { imageTmp, error in
                 guard let imageTmp = imageTmp else {
                     completionBlock(nil, error)
                     return
                 }
                 dewarpAndCleanupImage(imageTmp) { imageResult in
                     guard let imageResult = imageResult else {
                         completionBlock(nil, error)
                         return
                     }
                     completionBlock(imageResult)
                 }
             }
         }
     }
 }
 ```
 Partially because asynchronous APIs are onerous to use, there are many APIs
 defined in a synchronous form that can block (e.g. UIImage(named: ...)), and
 many of these APIs have no asynchronous alternative. Having a natural and
 canonical way to define and use these APIs will allow them to become pervasive.
 This is particularly important for new initiatives like the Swift on Server
 group.
 
 ====================================

 Network access is _the_ canonical asynchrony example.
*/
