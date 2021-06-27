import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol ApiEndpoint {
    var absoluteStringUrl: String { get }
    var url: URL? { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension ApiEndpoint {
    var url: URL? { .init(string: absoluteStringUrl) }
    var absoluteStringUrl: String { baseUrl + path }
    var method: HTTPMethod { .get }
    var baseUrl: String { "https://learningmap.free.beeceptor.com/" } // TODO load this from an envirnmnt
}
