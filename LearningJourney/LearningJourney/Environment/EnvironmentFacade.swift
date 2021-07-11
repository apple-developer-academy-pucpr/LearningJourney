import Foundation

public protocol EnvironmentFacade {
    static var baseUrl: String { get }
}

public enum DefaultEnvironment: EnvironmentFacade { // TODO consider this so that it can be modular
    
    private static let infoDictionary: [String : Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found! Check your environment settings")
        }
        return dict
    }()
    
    public static let baseUrl: String = {
        guard let baseUrl = infoDictionary["BASE_URL"] as? String else {
            fatalError("Base URL not found! Check your .xcconfig!")
        }
        return baseUrl
    }()
}
