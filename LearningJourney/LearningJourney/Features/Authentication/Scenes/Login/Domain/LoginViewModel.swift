import Combine

protocol LoginViewModeling: ObservableObject {
    func handleSignInWithApple()
}

final class LoginViewModel: LoginViewModeling {
    
    // MARK: - Inner types
    
    struct UseCases {
        let signInWithAppleUseCase: SignInWithAppleUseCase
    }
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    
    // MARK: - Initialization
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
    // MARK: - View modeling
    
    func handleSignInWithApple() {
        
    }
}
