import CoreAuthentication

enum ValidateTokenUseCaseError: Error {
    case invalidToken
}

protocol ValidateTokenUseCaseProtocol {
    func execute() -> Result<Void, ValidateTokenUseCaseError>
}

final class ValidateTokenUseCase: ValidateTokenUseCaseProtocol {
    
    // MARK: - Dependencies

    private let tokenProvider: TokenProviding
    
    // MARK: - Initialization
    
    init(tokenProvider: TokenProviding) {
        self.tokenProvider = tokenProvider
    }

    func execute() -> Result<Void, ValidateTokenUseCaseError> {
        tokenProvider.token
                .mapError { _ in .invalidToken }
                .map { _ in }
    }
}
