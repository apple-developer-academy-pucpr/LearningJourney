import Foundation

protocol LibraryRepositoryProtocol {
    typealias Completion<T> = (Result<T, LibraryRepositoryError>) -> Void
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>)
    func fetchObjectives(using goal: LearningGoal, completion: @escaping Completion<[LearningObjective]> )
}

enum LibraryRepositoryError: Error {
    case api(ApiError)
    case parsing(ParsingError)
    case unknown
}

final class LibraryRepository: LibraryRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let remoteService: LibraryRemoteServiceProtocol
    private let parser: LibraryParsing
    
    // MARK: - Initialization
    
    init(
        remoteService: LibraryRemoteServiceProtocol,
        parser: LibraryParsing
    ) {
        self.remoteService = remoteService
        self.parser = parser
    }

    // MARK: - Repositoryh methods
    
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>) {
        remoteService.learningStrands { [weak self] result in
            guard let self = self else {
                completion(.failure(.unknown))
                return
            }
            
            switch result {
            case let .success(payload):
                completion(self.parser.parse(payload)
                            .mapError { .parsing($0) })
            case let .failure(error):
                completion(.failure(.api(error)))
            }
        }
    }
    
    func fetchObjectives(
        using goal: LearningGoal,
        completion: @escaping Completion<[LearningObjective]>
    ) {
        remoteService.learningObjectives(using: goal.id) { [weak self] result in
            guard let self = self else {
                completion(.failure(.unknown))
                return
            }
            
            switch result {
            case let .success(payload):
                completion(self.parser.parse(payload)
                            .mapError { .parsing($0) })
            case let .failure(error):
                completion(.failure(.api(error)))
            }
        }
    }
}
