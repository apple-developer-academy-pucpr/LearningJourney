import SwiftUI

protocol LibraryScenesFactoryProtocol: AnyObject {
    func resolveLibraryScene(for feature: LibraryFeature, using route: LibraryRoute?) -> AnyView
    func resolveObjectivesListScene(for feature: LibraryFeature, using route: ObjectivesRoute) -> AnyView
    func resolveCreateObjectiveScene(for feature: LibraryFeature) -> AnyView
}

final class LibraryScenesFactory: LibraryScenesFactoryProtocol {
    
    // MARK: - Dependencies
    
    private let libraryAssembler: LibraryAssembling
    private let objectivesListAssembler: ObjectivesListAssembling
    private let createObjectiveAssembler: CreateObjectiveAssembling
    
    // MARK: - Initialization
    
    init(
        libraryAssembler: LibraryAssembling,
        objectivesListAssembler: ObjectivesListAssembling,
        createObjectiveAssembler: CreateObjectiveAssembler
    ) {
        self.libraryAssembler = libraryAssembler
        self.objectivesListAssembler = objectivesListAssembler
        self.createObjectiveAssembler = createObjectiveAssembler
    }
    
    // MARK: - Factory methods
    
    func resolveLibraryScene(for feature: LibraryFeature, using route: LibraryRoute?) -> AnyView { libraryAssembler.assemble(using: feature) }
    
    func resolveObjectivesListScene(for feature: LibraryFeature, using route: ObjectivesRoute) -> AnyView {
        objectivesListAssembler.assemble(using: feature, learningGoal: route.goal)
    }
    
    func resolveCreateObjectiveScene(for feature: LibraryFeature) -> AnyView {
        createObjectiveAssembler.assemble(using: feature)
    }
}
