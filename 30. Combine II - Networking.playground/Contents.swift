/*:
 # Combine II - Networking
 
 Now that we know we can use functional composition
 to compose a really big function from small readable
 parts, we can start to analyze places in our existing
 codebases that could benefit from this.
 
 The best place to start is anywhere we are doing asynchronous
 code and the first thing that springs to mind we
 we do that is network access.

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

 Network access is _the_ canonical asynchrony example.  The sort of callback
 driven approach to network access has been for decades the staple way
 of handling the problem.  The functional way is a bit different.  Here's
 an example of a real invocation which hits an endpoint and returns a model
 object.
 */
import Foundation
import Combine
/*:
 Let's start by creating a model object to hold the output.
*/
struct Configuration {
    let title : String
    let contents: [[Int]]
}
/*:
 And, let's make sure that it can be encoded in and out of JSON:
 */
extension Configuration: Codable { }
/*:
 Lets follow standard practice and make our API handle any errors
 we encounter:
 */
public enum APIError: Error {
    case urlError(URLError)
    case badResponse(URLResponse)
    case badResponseStatus(Int)
}
/*:
 Now lets use the Foundation-provided URLSession class to fetch
 a URL. (I'm using an easily accessible dropbox file as a stand in
 for a real API here.  We'll do something more elaborate later.
 */
var c1 = URLSession(configuration: URLSessionConfiguration.default)
    .dataTaskPublisher(for: URL(string: "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1")!)
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                "C'est finis!"
            case .failure(let error):
                print(error)
            }
        },
        receiveValue: { response in
            print(response)
        }
    )


var cancellable = URLSession(configuration: URLSessionConfiguration.default)
    .dataTaskPublisher(for: URL(string: "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1")!)
    .mapError { APIError.urlError($0) }
    .tryMap { data, response throws -> Data in
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse(response)
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.badResponseStatus(httpResponse.statusCode)
        }
        return data
    }
    .decode(type: [Configuration].self, decoder: JSONDecoder())
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                "C'est finis!"
            case .failure(let error):
                print(error)
            }
        },
        receiveValue: { configs in
            print(configs)
        }
    )
