import Foundation

import CoreNetworking

protocol LibraryRemoteServiceProtocol {
    typealias Completion = (Result<Data, ApiError>) -> Void
    func learningStrands(completion: @escaping Completion)
    func learningObjectives(using strandId: Int, completion: @escaping Completion)
    func updateObjective(using objective: LearningObjective, completion: @escaping Completion)
}

final class LibraryRemoteService: LibraryRemoteServiceProtocol {
    
    // MARK: - Dependencies
    
    private let apiFactory: ApiFactoryProtocol
    
    // MARK: - Properties
    
    private var currentRequest: ApiProtocol?
    
    // MARK: - Initialization
    
    init(apiFactory: ApiFactoryProtocol) {
        self.apiFactory = apiFactory
    }
    
    func learningStrands(completion: @escaping Completion ) {
        let endpoint: LibraryEndpoint = .fetchStrand
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func learningObjectives(using strandId: Int, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .fetchObjectives(strandId)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func updateObjective(using objective: LearningObjective, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .updateObjective(.init(
            id: objective.id,
            isComplete: objective.isComplete
        ))
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
}
