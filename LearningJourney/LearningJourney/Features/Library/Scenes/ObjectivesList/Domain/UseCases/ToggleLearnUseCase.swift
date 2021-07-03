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
            isCore: objective.isCore,
            isComplete: !objective.isComplete), completion: handle)
    }
}
