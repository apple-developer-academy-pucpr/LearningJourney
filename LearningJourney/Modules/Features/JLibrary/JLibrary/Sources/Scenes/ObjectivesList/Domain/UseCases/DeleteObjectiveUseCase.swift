protocol DeleteObjectiveUseCaseProtocol {
    func execute(objective: LearningObjective, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DeleteObjectiveUseCase: DeleteObjectiveUseCaseProtocol {
    private let repository: LibraryRepository
    
    init(repository: LibraryRepository) {
        self.repository = repository
    }
    
    func execute(objective: LearningObjective, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.delete(objective: objective) {
            completion($0.mapError { $0 })
        }
    }
}
