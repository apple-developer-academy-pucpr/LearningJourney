import Foundation

import CoreNetworking

protocol LibraryRemoteServiceProtocol {
    typealias Completion = (Result<Data, ApiError>) -> Void
    func learningStrands(completion: @escaping Completion)
    func learningObjectives(using strandId: String,
                            completion: @escaping Completion)
    func updateObjective(using objective: LibraryEndpoint.UpdateObjectiveModel,
                         completion: @escaping Completion)
    
    func newObjectiveMetadata(goalId: String, completion: @escaping Completion)
    func createObjective(using newObjectiveModel: LibraryEndpoint.NewObjectiveModel,
                         completion: @escaping Completion)
    func updateObjectiveDescription(objectiveId: String,
                                    newDescription: String,
                                    completion: @escaping Completion)
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
    
    func learningObjectives(using strandId: String, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .fetchObjectives(strandId)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func updateObjective(using objective: LibraryEndpoint.UpdateObjectiveModel, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .updateObjective(objective)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func newObjectiveMetadata(goalId: String, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .newObjectiveMetadata(goalId)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func createObjective(using newObjectiveModel: LibraryEndpoint.NewObjectiveModel,
                         completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .createObjective(newObjectiveModel)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
    
    func updateObjectiveDescription(objectiveId: String,
                                    newDescription: String,
                                    completion: @escaping Completion
    ) {
        let endpoint: LibraryEndpoint = .updateObjectiveDescription(objectiveId, newDescription)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: completion)
    }
}
