import SwiftUI

protocol ObjectivesListViewModelProtocol: ObservableObject {
    var objectives: LibraryViewModelState<[LearningObjective]> { get }
    var goalName: String { get }
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
    
    @Published
    var objectives: LibraryViewModelState<[LearningObjective]> = .loading
    
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
        useCases.fetchObjectivesUseCase.execute(using: dependencies.goal) { [weak self] in
            switch $0 {
            case let .success(objectives):
                self?.objectives = .result(objectives)
            case let .failure(error):
                self?.objectives = .error(error.localizedDescription)
            }
        }
    }
}
