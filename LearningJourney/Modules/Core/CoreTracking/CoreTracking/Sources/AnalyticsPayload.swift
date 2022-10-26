public protocol AnalyticsPayload {
    var name: String { get }
    var properties: [AnalyticsProperty]? { get }
}

// MARK: - Internal Helpers

extension AnalyticsPayload {
    var parameters: [String : AnyHashable]? {
        guard let properties = properties
        else { return nil }
        return .init(uniqueKeysWithValues: properties.map { ($0.name, $0.value) })
    }
}
