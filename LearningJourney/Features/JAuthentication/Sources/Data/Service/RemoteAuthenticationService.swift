import Foundation

import CoreNetworking

protocol RemoteAuthenticationServicing {
    typealias Completion = (Result<Data, ApiError>) -> Void
    func signInWithApple(using payload: SignInWithApplePayload, then handle: @escaping Completion)
}

final class RemoteAuthenticationService: RemoteAuthenticationServicing {
    
    // MARK: - Dependencies
    
    private let apiFactory: ApiFactory
    
    // MARK: - Properties
    
    private var currentRequest: ApiProtocol?
    
    // MARK: - Initialization
    
    init(apiFactory: ApiFactory) {
        self.apiFactory = apiFactory
    }
    
    // MARK: - Servicing
    
    func signInWithApple(using payload: SignInWithApplePayload, then handle: @escaping Completion) {
        let endpoint: AuthenticationEndpoint = .signInWithApple(payload)
        let apiRequest = apiFactory.make(endpoint)
        currentRequest = apiRequest.make(completion: handle)
    }
}
