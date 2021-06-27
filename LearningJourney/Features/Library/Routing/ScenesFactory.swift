import SwiftUI

protocol LibraryScenesFactoryProtocol: AnyObject {
    func resolveLibraryScene() -> AnyView
    func resolveObjectivesListScene(using goal: LearningGoal) -> AnyView
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
    
    func resolveLibraryScene() -> AnyView { libraryAssembler.assemble() }
    
    func resolveObjectivesListScene(using goal: LearningGoal) -> AnyView {
        objectivesListAssembler.assemble(learningGoal: goal)
    }
}
