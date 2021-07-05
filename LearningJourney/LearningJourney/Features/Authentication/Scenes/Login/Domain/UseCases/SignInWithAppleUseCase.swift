import AuthenticationServices

protocol SignInWithAppleUseCaseProtocol {
    typealias Completion = (Result<Void, SignInWithAppleUseCaseError>) -> Void
    func execute(
        using result:  Result<ASAuthorization, Error>,
        then handle: Completion)
}

enum SignInWithAppleUseCaseError: Error {
    case systemError(Error)
    case invalidCredentialType
}

final class SignInWithAppleUseCase: SignInWithAppleUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: AuthenticationRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Usecase methods
    
    func execute(
        using result:  Result<ASAuthorization, Error>,
        then handle: Completion) {
        switch result {
        case let .success(authorization):
            handleSiwaSuccess(using: authorization, completion: handle)
        case let .failure(error):
            handle(.failure(.systemError(error)))
        }
    }
    
    // MARK: - Helpers
    
    private func handleSiwaSuccess(using authorization: ASAuthorization, completion: Completion) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            completion(.failure(.invalidCredentialType))
            return
        }
        repository
    }
}
