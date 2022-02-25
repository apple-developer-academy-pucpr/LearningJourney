protocol FetchNewObjectiveMetadataUseCaseProtocol {
    typealias Completion = (Result<NewObjectiveMetadata, LibraryRepositoryError>) -> ()
    func execute(goalId: String, then handle: @escaping Completion)
}

final class FetchNewObjectiveMetadataUseCase: FetchNewObjectiveMetadataUseCaseProtocol {
    private let repository: LibraryRepositoryProtocol
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(goalId: String, then handle: @escaping Completion) {
        repository.fetchNewObjectiveMetadata(
            goalId: goalId,
            completion: handle)
    }
}
