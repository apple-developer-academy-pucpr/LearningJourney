protocol ToggleEagerToLearnUseCaseProtocol {
    typealias Completion = (Result<LearningObjective, LibraryRepositoryError>) -> ()
    func execute(objective: LearningObjective, then handle: @escaping Completion)
}

final class ToggleEagerToLearnUseCase: ToggleEagerToLearnUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(objective: LearningObjective, then handle: @escaping Completion) {
        repository.updateObjective(newObjective: .init(
            id: objective.id,
            code: objective.code,
            description: objective.description,
            type: objective.type,
            status: objective.status,
            isBookmarked: !objective.isBookmarked), completion: handle)
    }
}
