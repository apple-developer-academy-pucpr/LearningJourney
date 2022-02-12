protocol ToggleLearnUseCaseProtocol {
    typealias Completion = (Result<LearningObjective, LibraryRepositoryError>) -> ()
    func execute(objective: LearningObjective, then handle: @escaping Completion)
}

final class ToggleLearnUseCase: ToggleLearnUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Execution
    
    func execute(objective: LearningObjective, then handle: @escaping Completion) {
        repository.updateObjective(newObjective: .init(
            id: objective.id,
            code: objective.code,
            description: objective.description,
            type: objective.type,
            status: status(after: objective.status)), completion: handle)
    }
    
    private func status(after oldStatus: LearningObjectiveStatus) -> LearningObjectiveStatus {
        switch oldStatus {
        case .untutored, .eagerToLearn:
            return .learning
        case .learning:
            return .learned
        case .learned:
            return .mastered
        case .mastered:
            return .untutored
        }
    }
}
