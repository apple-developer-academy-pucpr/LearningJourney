protocol FetchObjectivesUseCaseProtocol {
    typealias Completion = (Result<[LearningObjective], LibraryRepositoryError>) -> ()
    func execute(using learningGoal: LearningGoal, then handle: @escaping Completion)
}

final class FetchObjectivesUseCase: FetchObjectivesUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Execution
    
    func execute(using learningGoal: LearningGoal, then handle: @escaping Completion) {
        repository.fetchObjectives(using: learningGoal, completion: handle)
    }
}
