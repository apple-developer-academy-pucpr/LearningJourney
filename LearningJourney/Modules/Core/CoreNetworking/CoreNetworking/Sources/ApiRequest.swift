import Foundation

import CoreAdapters

public enum ApiError: Error {
    case unknown
    case httpError(code: Int)
    case requestFailed(Error)
    case nonHTTPResponse
    case noData
    case unhandledtatusCode(Int)
    case clientError(Int)
    case externalError(Int)
    case invalidUrl
    case notAllowed
}

public protocol ApiProtocol: AnyObject {
    typealias Completion = (Result<Data, ApiError>) -> Void
    init(endpoint: ApiEndpoint)
    func make(completion: @escaping Completion) -> ApiProtocol?
}

public protocol ApiFactoryProtocol {
    func make(_ endpoint: ApiEndpoint) -> ApiProtocol
}

public final class ApiFactory: ApiFactoryProtocol {
    public init() {}
    public func make(_ endpoint: ApiEndpoint) -> ApiProtocol {
        ApiRequest(endpoint)
    }
}

public final class ApiRequest: ApiProtocol {
    
    // MARK: - Dependencies
    
    private let endpoint: ApiEndpoint
    private let session: URLSessionProtocol
    private let dispatchQueue: Dispatching
    
    // MARK: - Initialization
    
    public convenience init(endpoint: ApiEndpoint) {
        self.init(endpoint)
    }
    
    init(
        _ endpoint: ApiEndpoint,
        session: URLSessionProtocol = URLSession.shared, // TODO inject via proper injector
        dispatchQueue: Dispatching = DispatchQueue.main
    ) {
        self.endpoint = endpoint
        self.session = session
        self.dispatchQueue = dispatchQueue
    }
    
    // MARK: - ApiProtocol methods
    
    @discardableResult
    public func make(completion: @escaping Completion) -> ApiProtocol? {
        print("Making request on \(endpoint.absoluteStringUrl)")
        guard let url = endpoint.url else {
            completion(.failure(.invalidUrl))
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        endpoint.headers.forEach { header in
            request.addValue(header.formatted.1, forHTTPHeaderField: header.formatted.0)
        }
        let task = session.dataTask(request: request) { [weak self] data, response, error in
            guard let self = self else { return }
            let result = self.handleResponse(
                data: data,
                response: response,
                error: error)
            
            self.dispatchQueue.async {
                print("Got a result from \(self.endpoint.absoluteStringUrl): ", result)
                completion(result)
            }
        }
        task?.resume()
        return self
    }
    
    // MARK: - Helpers
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, ApiError> {
        if let error = error {
            return .failure(.requestFailed(error))
        }
        guard let response = response as? HTTPURLResponse
        else { return .failure(.nonHTTPResponse) }
        
        guard let data = data else
        { return .failure(.noData) }
        
        let responseStatus = response.statusCode
        switch responseStatus {
        case 0..<200:
            return .failure(.unhandledtatusCode(responseStatus))
        case 200..<300:
            return .success(data)
        case 401:
            return .failure(.notAllowed)
        case 400..<500:
            return .failure(.clientError(responseStatus))
        case 500..<600:
            return .failure(.externalError(responseStatus))
        default:
            return .failure(.unknown)
        }
    }
}
