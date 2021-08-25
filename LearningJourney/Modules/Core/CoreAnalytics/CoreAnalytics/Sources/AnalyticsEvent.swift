public enum AnalyticsDestination {
    case firebase
}

public protocol AnalyticsEvent {
    var name: String { get }
    var properties: [AnalyticsProperty]? { get }
    var destinations: [AnalyticsDestination] { get }
}

extension AnalyticsEvent {
    var destinations: [AnalyticsDestination] {
        [.firebase]
    }
}
