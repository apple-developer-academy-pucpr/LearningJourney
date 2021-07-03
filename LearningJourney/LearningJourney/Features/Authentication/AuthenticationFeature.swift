import SwiftUI

struct AuthenticationFeature<Coordinator> where Coordinator: AuthenticationCoordinating {
    
    // MARK: - Dependencies
    
    private let coordinator: Coordinator?
    
    // MARK: - Initialization
    
    public init() {
        let factory = AuthenticationSceneFactory()
        let coordinator = AuthenticationCoordinator(sceneFactory: factory)
        
        self.init(coordinator: coordinator as? Coordinator)
    }
    
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    // MARK: - Feature resolving
    func resolve() -> AnyView {
        guard let coordinator = coordinator else {
            fatalError("Coordinator not configured for Library feature")
        }
        return AnyView(coordinator
                        .start()
                        .environmentObject(coordinator))
    }
}
