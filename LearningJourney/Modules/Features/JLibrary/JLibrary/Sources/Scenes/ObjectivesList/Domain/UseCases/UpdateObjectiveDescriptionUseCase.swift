protocol UpdateObjectiveDescriptionUseCaseProtocol {
    func execute(objective: LearningObjective, newDescription: String, completion: @escaping (Result<LearningObjective, Error>) -> Void)
}

final class UpdateObjectiveDescriptionUseCase: UpdateObjectiveDescriptionUseCaseProtocol {
    
    private let repository: LibraryRepository
    
    init(repository: LibraryRepository) {
        self.repository = repository
    }
    
    func execute(objective: LearningObjective, newDescription: String, completion: @escaping (Result<LearningObjective, Error>) -> Void) {
        repository.updateObjectiveDescriotion(objective: objective, newDescription: newDescription) {
            completion($0.mapError { $0 })
        }
    }
}
