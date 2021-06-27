protocol FetchStrandsUseCaseProtocol {
    typealias Completion = (Result<[LearningStrand], LibraryRepositoryError>) -> ()
    func execute(then handle: @escaping Completion)
}

final class FetchStrandsUseCase: FetchStrandsUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Execution
    
    func execute(then handle: @escaping Completion) {
        repository.fetchStrands { result in
            handle(result)
        }
    }
}
