import SwiftUI

protocol LibraryCoordinating: ObservableObject {
    func objectivesView(goal: LearningGoal) -> AnyView
    func start() -> AnyView
}

final class LibraryCoordinator: LibraryCoordinating {
    
    // MARK: - Dependencies
    
    private let scenesFactory: LibraryScenesFactoryProtocol
    
    // MARK: - Initialization
    
    init(scenesFactory: LibraryScenesFactoryProtocol) {
        self.scenesFactory = scenesFactory
    }
    
    // MARK: - Coordinator factory
    
    func objectivesView(goal: LearningGoal) -> AnyView {
        scenesFactory.resolveObjectivesListScene(using: goal)
    }
    
    func start() -> AnyView {
        scenesFactory.resolveLibraryScene()
    }
}
