import SwiftUI

protocol LibraryCoordinating: ObservableObject {
    var isPresentingObjectives: Bool { get set }
    func objectivesView(goal: LearningGoal) -> AnyView
    func start() -> AnyView
}

final class LibraryCoordinator: LibraryCoordinating {
    @Published var isPresentingObjectives: Bool = false
    
    // MARK: - Dependencies
    
    weak var scenesFactory: LibraryScenesFactoryProtocol?
    
    // MARK: - Coordinating
    
    func objectivesView(goal: LearningGoal) -> AnyView {
        guard let factory = scenesFactory else {
            fatalError("Scene factory was not configured on this interactor")
        }
        return factory.resolveObjectivesListScene(using: goal)
    }
    
    func start() -> AnyView {
        guard let factory = scenesFactory else {
            fatalError("Scene factory was not configured on this interactor")
        }
        return factory.resolveLibraryScene()
    }
}
