import XCTest
import CoreAuthentication
import AuthenticationServices

@testable import JAuthentication

final class SignInWithAppleUseCaseTests: XCTestCase {

    // MARK: - Properties
    private let authorizationStub = ASAuthorizationStub()
    private let repositorySpy = AuthenticationRepositorySpy()
    private lazy var sut = SignInWithAppleUseCase(repository: repositorySpy)
    
    // MARK: - Unit tests
    
    func test_execute_whenSignInWithAppleFails_itShouldFailWithSystemError() {
        // Given / When
        sut.execute(using: .failure(DummyError.dummy)) { result in
            // Then
            guard case let .failure(error) = result,
                  case .systemError = error
            else {
                XCTFail("Expected to fail, but got success!")
                return
            }
        }
    }
    
    func test_execute_whenCredentialsAreNotProperlyTyped_itShouldFailWithInvalidCredentialType() {
        // Given / When
        sut.execute(using: .success(authorizationStub)) { result in
            // Then
            guard case let .failure(error) = result,
                  case .invalidCredentialType = error
            else {
                XCTFail("Expected to fail, but got success!")
                return
            }
        }
    }
    
    func test_execute_whenCredentialsAreRight_itShouldCallRepository() {
        // Given
        let expectation = XCTestExpectation()
        authorizationStub.credential = AuthorizationAppleIDCredentialDummy()
        
        // When
        sut.execute(using: .success(authorizationStub)) { result in
            // Then
            guard case .success = result
            else {
                XCTFail("Expected to succeed, but got failure \(result)!")
                return
            }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(1, repositorySpy.signInWithAppleCallCount)
    }
}

final class AuthenticationRepositorySpy: AuthenticationRepositoryProtocol {
    
    private(set) var signInWithAppleCallCount = 0
    func signInWithApple(using payload: SignInWithApplePayload, completion: @escaping Completion) {
        signInWithAppleCallCount += 1
        completion(.success(.fixture()))
    }
}

final class ASAuthorizationStub: ASAuthorizationProtocol {

    var credential: ASAuthorizationCredential = ASAuthorizationCredentialDummy()
}

final class ASAuthorizationCredentialDummy: NSObject, NSCoding, NSCopying, NSSecureCoding, ASAuthorizationCredential {
    
    override init() {}
    
    func encode(with coder: NSCoder) {}
    
    init?(coder: NSCoder) { return nil }
    
    func copy(with zone: NSZone? = nil) -> Any { self }
    
    static var supportsSecureCoding: Bool { false }
    
    
}

final class AuthorizationAppleIDCredentialDummy: NSObject, ASAuthorizationAppleIDCredentialProtocol, ASAuthorizationCredential{
    
    override init() {}
    
    func copy(with zone: NSZone? = nil) -> Any { self }
    
    static var supportsSecureCoding: Bool { false }
    
    func encode(with coder: NSCoder) {}
    
    init?(coder: NSCoder) { nil }
    
    var identityToken: Data?
    
    var user: String { "dummy" }
    
    var fullName: PersonNameComponents?
    
    var email: String?
    
    
}

enum DummyError: Error {
    case dummy
}
