import Foundation

protocol LibraryRemoteServiceProtocol {
    typealias Completion = (Result<Data, ApiError>) -> Void
    func learningStrands(completion: @escaping Completion)
    func learningObjectives(using strandId: UUID, completion: @escaping Completion)
}

final class LibraryRemoteService: LibraryRemoteServiceProtocol {
    
    // MARK: - Dependencies
    
    private let apiFactory: ApiFactory
    
    // MARK: - Properties
    
    private var currentRequest: ApiProtocol?
    
    // MARK: - Initialization
    
    init(apiFactory: @escaping ApiFactory) {
        self.apiFactory = apiFactory
    }
    
    func learningStrands(completion: @escaping Completion ) {
        let endpoint: LibraryEndpoint = .fetchStrand
        let apiRequest = apiFactory(endpoint)
        currentRequest = apiRequest.make { result in
            completion(result)
        }
    }
    
    func learningObjectives(using strandId: UUID, completion: @escaping Completion) {
        let endpoint: LibraryEndpoint = .fetchObjectives(strandId)
        let apiRequest = apiFactory(endpoint)
        currentRequest = apiRequest.make { result in
            completion(result)
        }
    }
}
