import SwiftUI

protocol LibraryScenesFactoryProtocol: AnyObject {
    func resolveLibraryScene(for feature: LibraryFeature, using route: LibraryRoute?) -> AnyView
    func resolveObjectivesListScene(using route: ObjectivesRoute) -> AnyView
}

final class LibraryScenesFactory: LibraryScenesFactoryProtocol {
    
    // MARK: - Dependencies
    
    private let libraryAssembler: LibraryAssembling
    private let objectivesListAssembler: ObjectivesListAssembling
    
    // MARK: - Initialization
    
    init(
        libraryAssembler: LibraryAssembling,
        objectivesListAssembler: ObjectivesListAssembling
    ) {
        self.libraryAssembler = libraryAssembler
        self.objectivesListAssembler = objectivesListAssembler
    }
    
    // MARK: - Factory methods
    
    func resolveLibraryScene(for feature: LibraryFeature, using route: LibraryRoute?) -> AnyView { libraryAssembler.assemble(using: feature) }
    
    func resolveObjectivesListScene(using route: ObjectivesRoute) -> AnyView {
        objectivesListAssembler.assemble(learningGoal: route.goal)
    }
}
