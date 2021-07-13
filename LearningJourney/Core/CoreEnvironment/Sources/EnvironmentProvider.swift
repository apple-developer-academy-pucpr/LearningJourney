import Foundation

public protocol EnvironmentProvider {
    static var baseUrl: String { get }
}

public enum DefaultEnvironment: EnvironmentProvider {
    
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
