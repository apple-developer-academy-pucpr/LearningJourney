import Combine
import AuthenticationServices

protocol LoginViewModeling: ObservableObject {
    func handleRequest(request: ASAuthorizationAppleIDRequest)
    func handleCompletion(result: Result<ASAuthorization, Error>)
}

final class LoginViewModel: LoginViewModeling {
    
    // MARK: - Inner types
    
    struct UseCases {
        let signInWithAppleUseCase: SignInWithAppleUseCaseProtocol
    }
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    
    // MARK: - Initialization
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
    // MARK: - View modeling
    
    func handleRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleCompletion(result: Result<ASAuthorization, Error>) {
        useCases.signInWithAppleUseCase.execute(using: result) { result in
            print("result is", result )
        }
    }
}
