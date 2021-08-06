import Foundation

public protocol EnvironmentProvider {
    static var baseUrl: String { get }
    static var environment: Environment? { get }
}

public enum Environment {
    case development
    case production
}

public final class DefaultEnvironment: EnvironmentProvider {
    
    private static let bundle: Bundle = {
        Bundle(for: DefaultEnvironment.self)
    }()
    
    private static let infoDictionary: [String : Any] = {
        guard let dict = bundle.infoDictionary else {
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
    
    public static let environment: Environment? = {
        guard let envName = infoDictionary["ENV_NAME"] as? String else {
            fatalError("ENV_NAME not found! Check your .xcconfig!")
        }
        switch envName {
        case "DEV":
            return .development
        case "PROD":
            return .production
        default:
            return .none
        }
    }()
}
