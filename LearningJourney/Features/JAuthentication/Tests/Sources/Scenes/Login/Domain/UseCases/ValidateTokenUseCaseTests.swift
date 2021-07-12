import XCTest
import CoreAuthentication

@testable import JAuthentication

final class ValidateTokenUseCaseTests: XCTestCase {

    // MARK: - Properties
    
    private let tokenProviderStub = TokenProviderStub()
    private lazy var sut = ValidateTokenUseCase(tokenProvider: tokenProviderStub)
    
    // MARK: - Unit tests
    
    func test_execute_whenProviderFails_itShouldMapToInvalidToken() {
        // Given / When
        let result = sut.execute()
        
        // Then
        guard case let .failure(error) = result,
              case .invalidToken = error
        else {
            XCTFail("Expected to fail, but got success instead!")
            return
        }
    }
    
    func test_execute_whenProviderSucceds_itShouldMapSuccess() {
        // Given
        tokenProviderStub.token = .success(.fixture())
        
        // When
        let result = sut.execute()
        
        // Then
        guard case .success = result
        else {
            XCTFail("Expected to succed, but got failure instead!")
            return
        }
    }
}


final class TokenProviderStub: TokenProviding {
    var token: Result<TokenPayload, TokenProviderError> = .failure(.notCached)
}
