protocol UpdateObjectiveDescriptionUseCaseProtocol {
    func execute(objective: LearningObjective, newDescription: String, completion: @escaping (Result<LearningObjective, Error>) -> Void)
}

final class UpdateObjectiveDescriptionUseCase: UpdateObjectiveDescriptionUseCaseProtocol {
    
    private let repository: LibraryRepositoryProtocol
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(objective: LearningObjective, newDescription: String, completion: @escaping (Result<LearningObjective, Error>) -> Void) {
        repository.updateObjectiveDescription(objective: objective, newDescription: newDescription) {
            completion($0.mapError { $0 })
        }
    }
}
