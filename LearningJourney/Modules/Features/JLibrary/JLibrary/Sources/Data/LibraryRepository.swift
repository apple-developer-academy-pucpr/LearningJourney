import Foundation

import CoreNetworking

protocol LibraryRepositoryProtocol {
    typealias Completion<T> = (Result<T, LibraryRepositoryError>) -> Void
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>)
    func fetchObjectives(using goal: LearningGoal, completion: @escaping Completion<[LearningObjective]> )
    func updateObjective(newObjective: LearningObjective, completion: @escaping Completion<LearningObjective>)
}

enum LibraryRepositoryError: Error {
    case api(ApiError)
    case parsing(ParsingError)
    case unauthorized
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
                if case .notAllowed = error {
                    completion(.failure(.unauthorized))
                    return
                }
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
            completion(self.mapResult(from: result))
        }
    }
    
    func updateObjective(newObjective: LearningObjective, completion: @escaping Completion<LearningObjective>) {
        remoteService.updateObjective(using: .init(
            id: newObjective.id,
            newStatus: newObjective.status,
            isBookmarked: newObjective.isBookmarked
        )) { [weak self] result in
            guard let self = self else {
                completion(.failure(.unknown))
                return
            }
            completion(self.mapResult(from: result))
        }
    }
    
    // MARK: - Helpers
    
    private func mapResult<T: Decodable>(from result: Result<Data, ApiError>) -> Result<T, LibraryRepositoryError> {
        switch result {
        case let .success(payload):
            return self.parser.parse(payload)
                        .mapError { .parsing($0) }
        case let .failure(error):
            return (.failure(.api(error)))
        }
    }
}
