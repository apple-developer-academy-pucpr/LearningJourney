import XCTest

import TestingUtils

@testable import JAuthentication

final class LoginAssemblerTests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = LoginAssembler()
    
    // MARK: - Unit tests
    func test_assemble_properlyAssemblesScene() throws {
        throw XCTSkip("TODO finish this test later. Must mock the feature's dependency container and check private properties of the repositores")
        let view = sut.assemble(using: .init())
        let viewModel = view.viewModel
        
        let viewModelMirror = Mirror(reflecting: viewModel)
        
        let useCases: LoginViewModel.UseCases = try XCTUnwrap(viewModelMirror.firstChild(named: "useCases"))
        
        let signInWithAppleUseCase = useCases.signInWithAppleUseCase
        let validateTokenUseCase = useCases.validateTokenUseCase
        
        XCTAssertTrue(validateTokenUseCase is ValidateTokenUseCase)
        XCTAssertTrue(signInWithAppleUseCase is SignInWithAppleUseCase)
    }
}
