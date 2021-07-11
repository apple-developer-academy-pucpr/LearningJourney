import Foundation

enum AuthenticationError: Error {
    case api(Error)
    case parsing(Error)
    case caching
    case notAuthenticated
}

protocol AuthenticationProviderProtocol {
    typealias Completion = (Result<TokenPayload, AuthenticationError>) -> Void
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion )
}

final class AuthenticationRepository: AuthenticationProviderProtocol {
    
    // MARK: - Dependencies
    
    private let parser: AuthenticationParsing
    private let remoteService: RemoteAuthenticationServicing
    private let cacheService: TokenSaving
    
    // MARK: - Initialization
    
    init(
        parser: AuthenticationParsing,
        remoteService: RemoteAuthenticationServicing,
        cacheService: TokenSaving = TokenManager.shared
    ) {
        self.parser = parser
        self.remoteService = remoteService
        self.cacheService = cacheService
    }
    
    // MARK: - Repository
    
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion) {
        remoteService.signInWithApple(using: payload) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let.success(data):
                if !self.cacheService.cache(token: data) {
                    completion(.failure(.caching))
                    return
                }
                completion(self.parser.parse(data).mapError{ .parsing($0) })
            case let .failure(error):
                completion(.failure(.api(error)))
            }
        }
    }
}
