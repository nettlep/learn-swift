import Foundation
import Combine

struct Configuration: Codable {
    let title : String
    let contents: [[Int]]
    
    init(title: String, contents: [[Int]]) throws {
        self.title = title
        self.contents = contents
    }
}

public enum APIError: Error {
    case urlError(URLError)
    case badResponse(URLResponse)
    case badResponseStatus(Int)
}

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
