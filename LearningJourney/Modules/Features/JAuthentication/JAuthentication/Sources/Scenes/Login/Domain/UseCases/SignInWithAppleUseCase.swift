import AuthenticationServices

protocol SignInWithAppleUseCaseProtocol {
    typealias Completion = (Result<Void, SignInWithAppleUseCaseError>) -> Void
    func execute(
        using result:  Result<ASAuthorizationProtocol, Error>,
        then handle: @escaping Completion)
}

enum SignInWithAppleUseCaseError: Error {
    case systemError(Error)
    case repository(AuthenticationError)
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
        using result:  Result<ASAuthorizationProtocol, Error>,
        then handle: @escaping Completion) {
        switch result {
        case let .success(authorization):
            handleSiwaSuccess(using: authorization, completion: handle)
        case let .failure(error):
            handle(.failure(.systemError(error)))
        }
    }
    
    // MARK: - Helpers
    
    private func handleSiwaSuccess(using authorization: ASAuthorizationProtocol, completion: @escaping Completion) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredentialProtocol
        else {
            completion(.failure(.invalidCredentialType))
            return
        }
        let payload = SignInWithApplePayload(
            identityToken: credentials.identityToken,
            appleId: credentials.user,
            fullName: credentials.fullName?.description,
            email: credentials.email)
        repository.signInWithApple(using: payload) {
            completion($0
                        .mapError { .repository($0)}
                        .map { _ in })
        }
    }
}
