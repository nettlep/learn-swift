/*:
 # Combine III - Networking
 
 Now that we know we can use functional composition
 to compose a really big function from small readable
 parts, we can start to analyze places in our existing
 codebases that could benefit from this.
 
 The best place to start is anywhere we are doing asynchronous
 code and the first thing that springs to mind when
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
    case badResponse
    case badResponseStatus(Int)
}
/*:
 And lets write a final handler for both errors and real values
 that we can attach at the end of the Combine chain.  (You'll
 need to open up the debug console at bottom to see the output
 as it happens).
 */
func log<E>(completion: Subscribers.Completion<E>) {
    switch completion {
    case .finished: "C'est finis!"
    case .failure(let error): print(error)
    }
}

func log<T>(data: T) {
    type(of: data)
    data
}
/*:
 Now lets use the Foundation-provided URLSession class to fetch
 a URL. (I'm using an easily accessible dropbox file as a stand in
 for a real API here.  We'll do something more elaborate later.
 */
let urlString = "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1"
var c1 = URLSession(configuration: URLSessionConfiguration.default)
    .dataTaskPublisher(for: URL(string: urlString)!)
    .sink(receiveCompletion: log(completion:), receiveValue: log(data:))
/*:
 And, just like that, we have asked the network for some data and it has given us
 a response.  This particular response was successful and handed us back 1543
 bytes in a buffer.  Had it failed, we would have seen the error be printed
 to stdout.
 
 Looking more closely we see that `dataTaskPublisher` publishes values of
 type (Data?, HTTPURLResponse?), i.e. a tuple of `Optional<Data>` and
 `Optional<HTTPURLResponse>`.  What does it mean for `response` to be `.none`?
 Well generally it means that the network is down. Stuff, as they say,
 happens and we need to protect against that.
 
 What does it mean for `data` to be `.none`?  Well if our URL were ill-formed
 or just plain wrong in some way there would be no way to give us back `data`
 and so it would be `.none` so we need to protect against that as well.
 
 So let's do a function which deals with this network-specific stuff.
 */
func verifyHttpResponse(data: Data?, response: URLResponse?) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.badResponse
    }
    guard httpResponse.statusCode == 200 else {
        throw APIError.badResponseStatus(httpResponse.statusCode)
    }
    return data ?? Data()
}
/*:
 And now lets stick that function in the middle of our `URL`-handling
 chain.
 */
var c2 = URLSession(configuration: URLSessionConfiguration.default)
    .dataTaskPublisher(for: URL(string: urlString)!)
    .tryMap(verifyHttpResponse)
    .sink(receiveCompletion: log(completion:), receiveValue: log(data:))
/*:
 We've added a `tryMap` which will verify the response and if the
 response exists and the response code is good, will return the data.
 If anything in the `tryMap` throws, we end up in `.sink` with completion
 being a `.failure`.
 
 And _THAT_ is how we meet Requirement 3 (Error handling) from the previous
 playground.
 
 In normal Swift usage if you `throw` an error in an API
 you enclose the code that might `throw` in a `do-catch` construct and
 handle the error at the call site, i.e. you `throw` the error backwards
 up the call chain. In Combine, however, you generally want to `throw`
 the error _forwards_ to the completion of the Combine chain which can
 seem almost counter-intuitive until you think about it a bit.
 
 So in this case, if anything in the `tryMap` throws, we will go
 into the `sink` with a completion of `.failure(theThrownError)`.
 
 There's lots more to Combine error handling than that, but this is
 enough to get us started.
 
 Now let's do something with that data that we have culled out of
 our request.  Let's decode its JSON into the model type that
 we created above `Configuration`, in this case `[Configuration]`.
 */
var c3 = URLSession(configuration: URLSessionConfiguration.default)
    .dataTaskPublisher(for: URL(string: urlString)!)
    .tryMap(verifyHttpResponse)
    .decode(type: [Configuration].self, decoder: JSONDecoder())
    .sink(receiveCompletion: log(completion:), receiveValue: log(data:))
/*:
 Now we have decoded the JSON data that we received back from the
 server into an array of our custom model objects. And boom
 we're done.  If at any point in the process we threw an error
 what happens?  We end up in the sink closure with a completion
 of type `failure` and we handle it there.
 
 Note how we have completely avoided the "pyramid of doom"
 that Latner and Groff discuss in the quote at the top of this
 playground.  Instead of nesting callbacks endlessly we have
 used functional composition to produce a very readable
 set of steps that are understandable to anyone who has
 worked with networking before.
 
 Lets go a little further and explore a common pattern that is
 often used when writing these kind of layers, using an enum
 to define the API in a type-safe manner
 */
