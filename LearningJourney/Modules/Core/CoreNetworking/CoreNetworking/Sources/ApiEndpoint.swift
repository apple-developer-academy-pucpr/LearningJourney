import Foundation
import CoreAuthentication
import CoreEnvironment

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public enum HTTPHeaderField {
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

public protocol ApiEndpoint {
    var absoluteStringUrl: String { get }
    var url: URL? { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [HTTPHeaderField] { get }
    var tokenProvider: TokenProviding? { get }
    var environment: EnvironmentProvider.Type { get  }
}

public extension ApiEndpoint {
    var absoluteStringUrl: String { baseUrl + path }
    var url: URL? { .init(string: absoluteStringUrl) }
    var baseUrl: String { environment.baseUrl }
    var method: HTTPMethod { .get }
    var body: Data? { nil }
    var headers: [HTTPHeaderField] {
        var headers: [HTTPHeaderField] = [.contentType("application/json")]
        if case let .success(token) = tokenProvider?.token {
            headers.append(.jwt(token.token))
        }
        return headers
    }
    var tokenProvider: TokenProviding? { TokenManager.shared }
    var environment: EnvironmentProvider.Type { DefaultEnvironment.self }
}

