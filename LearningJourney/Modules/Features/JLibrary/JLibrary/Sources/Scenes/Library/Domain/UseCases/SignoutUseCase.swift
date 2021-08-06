import CoreAuthentication

// TODO: consider moving this usecase to CoreAuthentication
protocol SignoutUseCaseProtocol {
    func execute()
}

final class SignoutUseCase: SignoutUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let cache: TokenCleaning
    
    // MARK: - Initialization
    
    init(cache: TokenCleaning) {
        self.cache = cache
    }
    
    // MARK: - Execute
    func execute() {
        cache.clear()
        NotificationCenter.default.post(name: .authDidChange, object: nil)
    }
}
