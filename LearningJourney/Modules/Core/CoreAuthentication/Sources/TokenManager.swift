import Foundation

public enum TokenProviderError: Error {
    case parsing(Error)
    case notCached
}

public protocol TokenProviding {
    var token: Result<TokenPayload, TokenProviderError> { get }
}

public protocol TokenSaving {
    func cache(token data: Data) -> Bool
}

public typealias TokenManaging = TokenProviding & TokenSaving

public final class TokenManager: TokenManaging {
    
    // MARK: - Shared instance
    
    public static let shared = TokenManager(cacheService: TokenCacheService()) // TODO handle this in a better way
    
    // MARK: - Dependencies
    
    private let cacheService: TokenCacheServicing
    
    // MARK: - Initialization
    
    init(cacheService: TokenCacheServicing) {
        self.cacheService = cacheService
    }
    
    // MARK: - Token providing
    
    public var token: Result<TokenPayload, TokenProviderError> {
        if let cached = cacheService.token {
            return parse(token: cached)
        }
        return .failure(.notCached)
    }
        
    // MARK: - Token configurator
    
    @discardableResult
    public func cache(token data: Data) -> Bool {
        cacheService.cache(token: data)
    }

    // MARK: - Helpers
    
    private func parse(token data: Data) -> Result<TokenPayload, TokenProviderError> {
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(TokenPayload.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.parsing(error))
        }
    }
}
