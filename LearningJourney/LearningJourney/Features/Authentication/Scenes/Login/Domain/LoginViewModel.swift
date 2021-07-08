import Combine
import AuthenticationServices

enum LoginViewState {
    case loading, error, result
}

protocol LoginViewModeling: ObservableObject {
    func handleRequest(request: ASAuthorizationAppleIDRequest)
    func handleCompletion(result: Result<ASAuthorization, Error>)
    
    func handleOnAppear()
    var isPresented: Bool { get set }
    var viewState: LoginViewState { get }
}

final class LoginViewModel: LoginViewModeling {
    
    // MARK: - Inner types
    
    struct UseCases {
        let signInWithAppleUseCase: SignInWithAppleUseCaseProtocol
        let validateTokenUseCase: ValidateTokenUseCaseProtocol
    }
    
    // MARK: - Properties
    
    @Published
    var isPresented: Bool = true
    @Published
    private(set) var viewState: LoginViewState = .loading
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    
    // MARK: - Initialization
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
    // MARK: - View modeling
    
    func handleOnAppear() {
        useCases.validateTokenUseCase.execute { result in
            switch result {
            case .success:
                dismiss()
            case .failure:
                viewState = .result
            }
        }
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleCompletion(result: Result<ASAuthorization, Error>) {
        useCases.signInWithAppleUseCase.execute(using: result) { [weak self] result in
            switch result {
            case .success:
                self?.dismiss()
            case .failure:
                self?.isPresented = true
            }
        }
    }
    
    // MARK: - Helpers
    
    private func dismiss() {
        isPresented = false
        NotificationCenter.default.post(
            name: .authDidChange,
            object: nil,
            userInfo: nil)
        objectWillChange.send()
    }
}

extension Notification.Name {
    static let authDidChange: Notification.Name = .init("authdidchange")
}
