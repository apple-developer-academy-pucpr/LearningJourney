import XCTest
import CoreAuthentication
import CoreNetworking

@testable import JAuthentication

final class AuthenticationRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private let parser = ParserStub()
    private let remoteService = RemoteServiceStub()
    private let cacheService = CacheServiceStub()
    
    private lazy var sut = AuthenticationRepository(
        parser: parser,
        remoteService: remoteService,
        cacheService: cacheService)
    
    // MARK: - Unit tests
    
    func test_signInWithApple_whenRemoteServiceFails_itShouldCompleteWithApiError() {
        // Given
        let expectation = XCTestExpectation()
        remoteService.resultToUse = .failure(.invalidUrl)
        
        // When
        sut.signInWithApple(using: .fixture()) { result in
            guard case let .failure(error) = result,
                  case .api = error
            else {
                XCTFail("Expected remote service to fail, but got success instead!")
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signInWithApple_whenCacheServiceFails_itShouldCompleteWithCachingError() throws {
        // Given
        let expectation = XCTestExpectation()
        let dummyToken = try XCTUnwrap(Data.tokenFixture())
        remoteService.resultToUse = .success(dummyToken)
        cacheService.cacheResultToUse = false
        
        // When
        sut.signInWithApple(using: .fixture()) { result in
            guard case let .failure(error) = result,
                  case .caching = error
            else {
                XCTFail("Expected remote service to fail, but got success instead!")
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signInWithApple_whenParsingFails_itShouldCompleteWithparsingError() throws {
        // Given
        let expectation = XCTestExpectation()
        let dummyError = NSError(domain: "", code: 0, userInfo: nil)
        remoteService.resultToUse = .success(.init())
        cacheService.cacheResultToUse = true
        parser.errorToUse = .invalidData(dummyError)
        
        // When
        sut.signInWithApple(using: .fixture()) { result in
            // Then
            guard case let .failure(error) = result,
                  case .parsing = error
            else {
                XCTFail("Expected remote service to fail, but got success instead!")
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signInWithApple_whenSucceeds_itShouldCompleteWithTokenPayload() throws {
        // Given
        let expectation = XCTestExpectation()
        let expectedTokenString = "salve"
        let dummyToken = TokenPayload(token: expectedTokenString)
        
        remoteService.resultToUse = .success(.init())
        cacheService.cacheResultToUse = true
        parser.tokenToUse = dummyToken
        
        // When
        sut.signInWithApple(using: .fixture()) { result in
            // Then
            guard case let .success(actualPayload) = result
            else {
                XCTFail("Expected remote service to succeed, but got failure instead!")
                return
            }
            XCTAssertEqual(actualPayload.token, expectedTokenString)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Testing doubles

final class ParserStub: AuthenticationParsing {
    
    var tokenToUse: TokenPayload?
    var errorToUse: ParsingError?
    
    func parse<T>(_ data: Data) -> Result<T, ParsingError> where T : Decodable {
        if let token = tokenToUse as? T {
            return .success(token)
        }
        
        if let error = errorToUse {
            return .failure(error)
        }
        
        fatalError("Nothing was set on the parser stub!")
    }
}

final class RemoteServiceStub: RemoteAuthenticationServicing {
    
    var resultToUse: Result<Data, ApiError> = .failure(.nonHTTPResponse)
    
    func signInWithApple(using payload: SignInWithApplePayload, then handle: @escaping Completion) {
        handle(resultToUse)
    }
}

final class CacheServiceStub: TokenSaving {
    var cacheResultToUse = true
    func cache(token data: Data) -> Bool {
        cacheResultToUse
    }
}

extension Data {
    static func tokenFixture(
        token: String = "dummy"
    ) -> Data? {
        let tokenData = "{ token: \(token) }"
        return tokenData.data(using: .utf8)
    }
}

extension TokenPayload {
    static func fixture(
        token: String = "dummy"
    ) -> Self {
        .init(token: token)
    }
}

extension SignInWithApplePayload {
    static func fixture(
        identityToken: Data? = nil,
        appleId: String = "dummy",
        fullName: String? = nil,
        email: String? = nil
    ) -> SignInWithApplePayload {
        .init(
            identityToken: identityToken,
            appleId: appleId,
            fullName: fullName,
            email: email)
    }
}
