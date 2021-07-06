import Foundation

enum AuthenticationRepositoryError: Error {
    case api(Error)
    case parsing(Error)
    case caching(Int32)
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
    private let remoteService: RemoteAuthenticationServicing
    private let cacheService: CacheAuthenticationServicing
    
    // MARK: - Initialization
    
    init(
        parser: AuthenticationParsing,
        remoteService: RemoteAuthenticationServicing,
        cacheService: CacheAuthenticationServicing
    ) {
        self.parser = parser
        self.remoteService = remoteService
        self.cacheService = cacheService
    }
    
    // MARK: - Repository
    
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion) {
        
        if let cached = cacheService.token {
            completion(parser.parse(cached).mapError { .parsing($0) })
            return
        }
        remoteService.signInWithApple(using: payload) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let.success(data):
//                if !self.cacheService.cache(token: data) {
//                    completion(.failure(.caching(self.cacheService.lastResultCode)))
//                    return
//                }
                completion(self.parser.parse(data).mapError{ .parsing($0) })
            case let .failure(error):
                completion(.failure(.api(error)))
            }
        }
    }
}
