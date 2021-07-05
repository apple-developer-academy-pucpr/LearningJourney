import Foundation

enum AuthenticationRepositoryError: Error {
    case api(Error)
}

protocol AuthenticationRepositoryProtocol {
    typealias Completion = (Result<TokenPayload, AuthenticationRepositoryError>) -> Void
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion )
}

struct TokenPayload: Decodable {
    let token: String
}

final class AuthenticationRepository: AuthenticationRepositoryProtocol {
    // MARK: - Dependencies
    
    private let parser: AuthenticationParsing
    private let service: RemoteAuthenticationServicing
    
    // MARK: - Initialization
    
    init(parser: AuthenticationParsing, service: RemoteAuthenticationServicing) {
        self.parser = parser
        self.service = service
    }
    
    // MARK: - Repository
    
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion) {
        // TODO check if there is a token in cache
        service.signInWithApple(using: payload) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let.success(data):
                completion(self.parser.parse(data).mapError{ .api($0) })
            case let .failure(error):
                completion(.failure(.api(error)))
            }
        }
    }
}
