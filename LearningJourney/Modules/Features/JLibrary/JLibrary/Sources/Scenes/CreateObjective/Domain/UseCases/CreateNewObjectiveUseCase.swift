protocol CreateNewObjectiveUseCaseProtocol {
    typealias Completion = (Result<LearningObjective, LibraryRepositoryError>) -> ()
    func execute(goalId: String, description: String, completion: @escaping Completion)
}

final class CreateNewObjectiveUseCase: CreateNewObjectiveUseCaseProtocol {
    private let repository: LibraryRepositoryProtocol
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(goalId: String, description: String, completion: @escaping Completion) {
        repository.createObjective(goalId: goalId, description: description, completion: completion)
    }
}
