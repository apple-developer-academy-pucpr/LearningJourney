import XCTest
import TestingUtils
import AuthenticationServices

@testable import JAuthentication

final class LoginViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private let signInUseCase = SignInWithAppleUseCaseMock()
    private let validateTokenCaseStub = ValidateTokenUseCaseStub()
    private let notificationCenterSpy = NotificationCenterSpy()
    
    private lazy var sut = LoginViewModel(
        useCases: .init(
            signInWithAppleUseCase: signInUseCase,
            validateTokenUseCase: validateTokenCaseStub
        ),
        notificationCenter: notificationCenterSpy)
    
    // MARK: - Unit tests
    
    func test_handleOnAppear_whenResultSucceeds_itShouldDismiss() {
        // Given / When
        sut.handleOnAppear()
        
        // Then
        XCTAssertFalse(sut.isPresented)
        XCTAssertEqual(notificationCenterSpy.postCallCount, 1)
    }
    
    func test_handleCompletion_whenResultFails_itShouldPresentResult() {
        // Given
        validateTokenCaseStub.errorToUse = .invalidToken
        
        // When
        sut.handleOnAppear()
        
        // Then
        XCTAssertEqual(sut.viewState, .result)
        XCTAssertTrue(sut.isPresented)
    }
    
    func test_handleCompletion_whenUseCaseFails_itShouldStayPresented() {
        // Given / When
        sut.handleCompletion(result: .failure(DummyError.dummy))
        
        // Then
        XCTAssertEqual(sut.viewState, .result)
        XCTAssertTrue(sut.isPresented)
    }
    
    func test_handleCompletion_whenUseCaseSucceeds_itShouldDismiss() {
        // Given
        signInUseCase.resultToUse = .success({}())
        
        // When
        sut.handleCompletion(result: .failure(DummyError.dummy))
        
        // Then
        XCTAssertFalse(sut.isPresented)
        XCTAssertEqual(notificationCenterSpy.postCallCount, 1)
    }
    
    func test_handleCompletion_properlyLoads() {
        // Given
        signInUseCase.shouldHandle = false
        
        // When
        sut.handleCompletion(result: .failure(DummyError.dummy))
        
        // Then
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func test_handleAuthStatusChange_whenItSucceeds_itShouldDismiss() {
        // Given
        validateTokenCaseStub.errorToUse = nil
        
        // When
        sut.handleAuthStatusChange(.fixture())
        
        // Then
        XCTAssertFalse(sut.isPresented)
        XCTAssertEqual(notificationCenterSpy.postCallCount, 1)
    }
    
    func test_handleAuthStatusChange_whenItSucceeds_andViewIsAlreadyDismissed_itShouldNotDismiss() {
        // Given
        sut.isPresented = false
        validateTokenCaseStub.errorToUse = nil
        
        // When
        sut.handleAuthStatusChange(.fixture())
        
        // Then
        XCTAssertEqual(notificationCenterSpy.postCallCount, 0)
        
    }
    
    func test_handleRequest_properlyConfiguresRequest() {
        // Given
        let fakeRequest = ASAuthorizationAppleIDRequestFake()
        
        // When
        sut.handleRequest(request: fakeRequest)
        
        // Then
        XCTAssertEqual(fakeRequest.requestedScopes?.count, 2)
        
        
    }
}

final class SignInWithAppleUseCaseMock: SignInWithAppleUseCaseProtocol {
    var resultToUse: Result<Void, SignInWithAppleUseCaseError> = .failure(.invalidCredentialType)
    
    var shouldHandle = true
    func execute(using result: Result<ASAuthorizationProtocol, Error>, then handle: @escaping Completion) {
        guard shouldHandle else { return }
        handle(resultToUse)
    }
}

final class ValidateTokenUseCaseStub: ValidateTokenUseCaseProtocol {
    var errorToUse: ValidateTokenUseCaseError?
    
    func execute() -> Result<Void, ValidateTokenUseCaseError> {
        if let error = errorToUse {
            return .failure(error)
        }
        return .success({}())
    }
}

extension NotificationCenter.Publisher.Output {
    static func fixture(
        name: Name = .init("asdad"),
        object: AnyObject? = nil,
        userInfo: [AnyHashable : Any]? = nil
    ) -> Self {
        NotificationCenter.Publisher.Output(
            name: name,
            object: object,
            userInfo: userInfo
        )
    }
}

final class ASAuthorizationAppleIDRequestFake: ASAuthorizationAppleIDRequestProtocol {
    var requestedScopes: [ASAuthorization.Scope]?
}
