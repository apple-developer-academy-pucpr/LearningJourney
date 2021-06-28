import SwiftUI

struct LibraryFeature<Coordinator> where Coordinator: LibraryCoordinating {
    
    // MARK: - Dependencies
    
    private let coordinator: Coordinator?
    private let sceneFactory: LibraryScenesFactoryProtocol
    
    // MARK: - Initialization
    
    public init() {
        let factory = LibraryScenesFactory(
            libraryAssembler: LibraryAssembler(),
            objectivesListAssembler: ObjectivesListAssembler()
        )
        
        let coordinator = LibraryCoordinator(scenesFactory: factory)
        self.init(
            coordinator: coordinator as? Coordinator,
            sceneFactory: factory
        )
    }
    
    init(
        coordinator: Coordinator?,
        sceneFactory: LibraryScenesFactoryProtocol ) {
        self.coordinator = coordinator
        self.sceneFactory = sceneFactory
    }
    
    func resolve() -> AnyView {
        guard let coordinator = coordinator else {
            fatalError("Coordinator not configured for Library feature")
        }
        return AnyView(coordinator
                        .start()
                        .environmentObject(coordinator))
            
    }
}
