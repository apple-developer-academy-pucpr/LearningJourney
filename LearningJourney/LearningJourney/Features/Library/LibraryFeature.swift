import SwiftUI

struct LibraryFeature<Coordinator> where Coordinator: LibraryCoordinating {
    
    // MARK: - Dependencies
    
    private let coordinator: Coordinator?
    
    // MARK: - Initialization
    
    public init() {
        let factory = LibraryScenesFactory(
            libraryAssembler: LibraryAssembler(),
            objectivesListAssembler: ObjectivesListAssembler()
        )
        
        let coordinator = LibraryCoordinator(scenesFactory: factory)
        self.init(
            coordinator: coordinator as? Coordinator
        )
    }
    
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
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
