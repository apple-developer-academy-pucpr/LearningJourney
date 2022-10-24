import Foundation
import CoreNetworking

struct SignInWithApplePayload: Encodable {
    let identityToken: Data?
    let appleId: String
    let fullName: String?
    let email: String?
}

enum AuthenticationEndpoint {
    case signInWithApple(SignInWithApplePayload)
}

extension AuthenticationEndpoint: ApiEndpoint {
    var path: String { "auth/apple" }
    var method: HTTPMethod { .post }
    var body: Data? {
        switch self {
        case let .signInWithApple(payload):
            return signInWithApplePayload(payload)
        }
    }
    
    // MARK: - Helpers
    
    private func signInWithApplePayload(_ payload: SignInWithApplePayload) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(payload)
    }
}
