import XCTest

@testable import JAuthentication

final class LoginViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private let signInUseCase = SignInWithAppleUseCaseMock()
    private let validateTokenCaseStub = ValidateTokenUseCaseStub()
    private lazy var  sut = LoginViewModel(
        useCases: .init(
            signInWithAppleUseCase: signInUseCase,
            validateTokenUseCase: validateTokenCaseStub
        ))
    
    // MARK: - Unit tests
    
    func test_handleOnAppear_whenResultSucceeds_itShouldDismiss() {
        // Given / When
        sut.handleOnAppear()
        
        // Then
        XCTAssertFalse(sut.isPresented)
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
    }
    
    func test_handleCompletion_properlyLoads() {
        // Given
        signInUseCase.shouldHandle = false
        
        // When
        sut.handleCompletion(result: .failure(DummyError.dummy))
        
        // Then
        XCTAssertEqual(sut.viewState, .loading)
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
