import Foundation

public enum AnalyticsDestination {
    case firebase
}

public protocol AnalyticsDispatching {
    var destinations: [AnalyticsDestination] { get }
}

// MARK: - Default values

public extension AnalyticsDispatching {
    var destinations: [AnalyticsDestination] {
        [.firebase]
    }
}

