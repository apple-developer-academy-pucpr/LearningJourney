import SwiftUI
import UI

protocol ObjectivesListViewModelProtocol: ObservableObject {
    var objectives: LibraryViewModelState<[LibraryViewModelState<LearningObjective>]> { get }
    var goalName: String { get }
    func handleOnAppear()
    func handleDidLearnToggled(objective state: LibraryViewModelState<LearningObjective>)
}

final class ObjectivesListViewModel: ObjectivesListViewModelProtocol {
    
    // MARK: - Inner types
    
    struct UseCases {
        let fetchObjectivesUseCase: FetchObjectivesUseCaseProtocol
        let toggleLearnUseCase: ToggleLearnUseCaseProtocol
    }
    
    struct Dependencies {
        let goal: LearningGoal
    }
    
    // MARK: - ViewModel properties
    
    typealias Objectives = LibraryViewModelState<[LibraryViewModelState<LearningObjective>]>
    
    @Published
    var objectives: Objectives = .loading
    
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
        objectives = .loading
        useCases.fetchObjectivesUseCase.execute(using: dependencies.goal) { [weak self] in
            switch $0 {
            case let .success(objectives):
                self?.objectives = .result(objectives.map { .result($0) })
            case let .failure(error):
                self?.handleError(error)
            }
        }
    }
    
    func handleDidLearnToggled(objective state: LibraryViewModelState<LearningObjective>) {
        guard case let .result(oldObjective) = state,
              case var .result(objectives) = objectives,
              let selectedIndex = objectives.firstIndex(where: { $0 == state })
        else { return }
        
        objectives[selectedIndex] = .loading
        self.objectives = .result(objectives)
        
        useCases.toggleLearnUseCase.execute(objective: oldObjective) { [weak self] in
            switch $0 {
            case let .success(objective):
                objectives[selectedIndex] = .result(objective)
                self?.objectives = .result(objectives)
            case .failure:
                objectives[selectedIndex] = .result(oldObjective) // TODO this should present a button so that the user can try again
                self?.objectives = .result(objectives)
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
