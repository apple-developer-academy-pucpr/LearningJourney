import SwiftUI

protocol AuthenticationCoordinating: ObservableObject {
    func start() -> AnyView
}

final class AuthenticationCoordinator: AuthenticationCoordinating {
    
    // MARK: - Dependencies
    
    private let sceneFactory: AuthenticationSceneFactoryProtocol
    
    // MARK: - Initialization
    
    init(sceneFactory: AuthenticationSceneFactoryProtocol) {
        self.sceneFactory = sceneFactory
    }
    
    func start() -> AnyView { sceneFactory.loginScene() }
}
