import XCTest

@testable import CoreAuthentication

final class TokenManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private let spy = TokenCacheMock()
    private lazy var sut = TokenManager(cacheService: spy)
    
    // MARK: - Unit tests
    
    func test_token_whenCacheIsEmpty_itShouldFail_withNotCached() {
        // Given
        let expectedError = TokenProviderError.notCached.localizedDescription
        
        // When
        let token = sut.token
        
        // Then
        guard case let .failure(error) = token else {
            XCTFail("Expected token to not be cached, but got success instead!")
            return
        }
        XCTAssertEqual(error.localizedDescription, expectedError)
    }
    
    func test_token_whenCacheFailsParsing_itShouldReturnParingError() {
        // Given
        spy.token = Data(repeating: 1, count: 1)
        
        // When
        let token = sut.token
        
        // Then
        guard case let .failure(error) = token,
              case .parsing = error
        else {
            XCTFail("Expected token to not be cached, but got success instead!")
            return
        }
    }
    
    func test_token_whenTokenIsCached_itShouldReturnTokenPayload() throws {
        // Given
        let expectedString = "token"
        let payloadDummy = TokenPayload(token: expectedString)
        spy.token = try JSONEncoder().encode(payloadDummy)
        
        // When
        let token = sut.token
        
        // Then
        guard case let .success(payload) = token
        else {
            XCTFail("Expected token to not be cached, but got success instead!")
            return
        }
        
        XCTAssertEqual(payload.token, expectedString)
    }
    
    func test_cache_itShouldCallCacheService() {
        // Given / When
        sut.cache(token: .init())
        
        // Then
        XCTAssertEqual(spy.cacheCallCount, 1)
    }
}


final class TokenCacheMock: TokenCacheServicing {
    var token: Data?
    
    private(set) var cacheCallCount = 0
    func cache(token: Data) -> Bool {
        cacheCallCount += 1
        return true
    }
}
