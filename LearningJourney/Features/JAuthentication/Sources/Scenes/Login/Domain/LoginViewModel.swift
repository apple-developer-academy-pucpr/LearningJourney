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
        let result = useCases
            .validateTokenUseCase
            .execute()
        
        switch result {
        case .success:
            dismiss()
        case .failure:
            viewState = .result
        }
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequest) { // TODO this should be testable
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleCompletion(result: Result<ASAuthorization, Error>) {
        viewState = .loading
        useCases.signInWithAppleUseCase.execute(using: result.map { $0 }) { [weak self] result in
            self?.viewState = .result
            switch result {
            case .success:
                self?.dismiss()
            case .failure:
                self?.isPresented = true
            }
        }
        
        objectWillChange.send()
    }
    
    // MARK: - Helpers
    
    private func dismiss() {
        isPresented = false
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .authDidChange,
                object: nil,
                userInfo: nil)
        }
        objectWillChange.send()
    }
}

public extension Notification.Name {
    static let authDidChange: Notification.Name = .init("authdidchange")
}
