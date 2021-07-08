import SwiftUI

protocol AuthenticationSceneFactoryProtocol {
    func loginScene() -> AnyView
}

final class AuthenticationSceneFactory: AuthenticationSceneFactoryProtocol {
    
    // MARK: - Dependencies
    private let loginAssembler: LoginAssembling
    
    // MARK: - Initialization
    init(loginAssembler: LoginAssembling) {
        self.loginAssembler = loginAssembler
    }
    
    // MARK: - Factory methods
    
    func loginScene() -> AnyView {
        AnyView(loginAssembler.assemble())
    }
}
