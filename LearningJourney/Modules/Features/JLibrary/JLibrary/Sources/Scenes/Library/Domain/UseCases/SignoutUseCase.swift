import CoreAuthentication
import CoreAdapters

// TODO: consider moving this usecase to CoreAuthentication
protocol SignoutUseCaseProtocol {
    func execute()
}

final class SignoutUseCase: SignoutUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let cache: TokenCleaning
    private let notificationCenter: NotificationCenterProtocol
    
    // MARK: - Initialization
    
    init(cache: TokenCleaning,
         notificationCenter: NotificationCenterProtocol) {
        self.cache = cache
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Execute
    func execute() {
        cache.clear()
        notificationCenter.post(name: .authDidChange)
    }
}
