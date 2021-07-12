import CoreAuthentication

enum ValidateTokenUseCaseError: Error {
    case invalidToken
}

protocol ValidateTokenUseCaseProtocol {
    typealias Completion = (Result<Void, ValidateTokenUseCaseError>) -> Void
    func execute(then handle: Completion)
}

final class ValidateTokenUseCase: ValidateTokenUseCaseProtocol {
    
    // MARK: - Dependencies

    private let tokenProvider: TokenProviding
    
    // MARK: - Initialization
    
    init(tokenProvider: TokenProviding) {
        self.tokenProvider = tokenProvider
    }

    func execute(then handle: Completion) {
        handle(tokenProvider.token
                .mapError { _ in .invalidToken }
                .map { _ in }
        )
    }
}
