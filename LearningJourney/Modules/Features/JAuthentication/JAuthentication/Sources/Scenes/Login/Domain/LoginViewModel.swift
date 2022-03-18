import Combine
import AuthenticationServices
import CoreAdapters
import CoreAuthentication

enum LoginViewState {
    case loading, error, result
}

protocol LoginViewModeling: ObservableObject {
    func handleRequest(request: ASAuthorizationAppleIDRequestProtocol)
    func handleCompletion(result: Result<ASAuthorization, Error>)
    func handleOnAppear()
    func handleAuthStatusChange(_ output: NotificationCenter.Publisher.Output)
    
    var isPresented: Bool { get set }
    var isShowingSIWAAlert: Bool { get set }
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
    var isShowingSIWAAlert: Bool = false
    @Published
    private(set) var viewState: LoginViewState = .loading
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    private let notificationCenter: NotificationCenterProtocol
    
    // MARK: - Initialization
    
    init(
        useCases: UseCases,
        notificationCenter: NotificationCenterProtocol
    ) {
        self.useCases = useCases
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - View modeling
    
    func handleOnAppear() {
        presentIfNeeded()
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequestProtocol) { // TODO this should be testable
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleCompletion(result: Result<ASAuthorization, Error>) {
        viewState = .loading
        useCases.signInWithAppleUseCase.execute(using: result.map { $0 }) { [weak self] result in
            self?.viewState = .result
            switch result {
            case .success:
                self?.dismiss()
            case let .failure(SignInWithAppleUseCaseError.repository(err)) where
                AuthenticationError.api(.clientError(400)).localizedDescription == err.localizedDescription:
                self?.isShowingSIWAAlert = true
                fallthrough
            case .failure:
                self?.isPresented = true
            }
        }
    }
    
    func handleAuthStatusChange(_ output: NotificationCenter.Publisher.Output) {
        presentIfNeeded()
    }
    
    // MARK: - Helpers
    
    private func dismiss() {
        if !isPresented { return }
        isPresented = false
        notificationCenter.post(
            name: .authDidChange)
        objectWillChange.send()
    }
    
    private func presentIfNeeded() {
        let result = useCases
            .validateTokenUseCase
            .execute()
        
        switch result {
        case .success:
            dismiss()
        case .failure:
            isPresented = true
            viewState = .result
        }
    }
}

// MARK: - Adapters

protocol ASAuthorizationAppleIDRequestProtocol: AnyObject {
    var requestedScopes: [ASAuthorization.Scope]? { get set }
}

extension ASAuthorizationAppleIDRequest: ASAuthorizationAppleIDRequestProtocol {}
