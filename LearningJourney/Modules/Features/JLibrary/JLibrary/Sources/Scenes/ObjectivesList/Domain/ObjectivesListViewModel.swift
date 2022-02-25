import SwiftUI
import UI

protocol ObjectivesListViewModelProtocol: ObservableObject {
    var objectives: LibraryViewModelState<[LearningObjective]> { get }
    var goalName: String { get }
    var goal: LearningGoal { get }
    func handleOnAppear()
}

final class ObjectivesListViewModel: ObjectivesListViewModelProtocol {
    
    // MARK: - Inner types
    
    struct UseCases {
        let fetchObjectivesUseCase: FetchObjectivesUseCaseProtocol
    }
    
    struct Dependencies {
        let goal: LearningGoal
    }
    
    // MARK: - ViewModel properties
    
    typealias Objectives = LibraryViewModelState<[LearningObjective]>
    
    @Published
    var objectives: Objectives = .empty
    var goal: LearningGoal { dependencies.goal }
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    private let dependencies: Dependencies
    
    // MARK: - Initialization
    
    init(
        useCases: UseCases,
        dependencies: Dependencies
    ) {
        self.useCases = useCases
        self.dependencies = dependencies
    }
    
    // MARK: - ViewModel Protocol
    
    var goalName: String { dependencies.goal.name }
    
    func handleOnAppear() {
        if objectives == .loading { return }
        objectives = .loading
        useCases.fetchObjectivesUseCase.execute(using: dependencies.goal) { [weak self] in
            switch $0 {
            case let .success(objectives):
                self?.objectives = .result(objectives)
            case let .failure(error):
                self?.handleError(error)
            }
        }
    }
    
    // MARK: - Helper functions
    
    private func handleError(_ error: LibraryRepositoryError) {
        switch error {
        case .unauthorized:
            objectives = .error(.notAuthenticated)
        case .api, .parsing, .unknown:
            objectives = .error(.unknown (handleOnAppear))
        }
    }
}
