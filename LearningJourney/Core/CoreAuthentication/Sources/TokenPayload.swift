public struct TokenPayload: Codable {
    
    // MARK: - Properties
    
    public let token: String
    
    // MARK: - Initialization
    
    public init(token: String) {
        self.token = token
    }
}
