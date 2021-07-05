import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPHeaderField {
    case jwt(_ token: String)
    case contentType(_ mime: String)
    
    var formatted: (String, String) {
        switch self {
        case let .jwt(token):
            return ("Authorization", "Bearer \(token)")
        case let .contentType(mime):
            return ("Content-Type", mime)
        }
    }
}

protocol ApiEndpoint {
    var absoluteStringUrl: String { get }
    var url: URL? { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [HTTPHeaderField] { get }
}

extension ApiEndpoint {
    var url: URL? { .init(string: absoluteStringUrl) }
    var absoluteStringUrl: String { baseUrl + path }
    var method: HTTPMethod { .get }
    var baseUrl: String { "http://192.168.0.106:3000/api/" } // TODO load this from an envirnmnt
    var body: Data? { nil }
    var headers: [HTTPHeaderField] {[
        .jwt("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQQVNUUkUiLCJpYXQiOjE2MjUyMDQ5MTcsImV4cCI6IiswMTAyMzUtMDMtMjNUMDU6NDg6MzcuMTAwWiIsInVzZXIiOnsiaWQiOjF9fQ.D48JP7-DA3INR3lnCe1H60zdYB-n9trFe8SOu0J_ZzM"),
        .contentType("application/json")
    ]}
}
