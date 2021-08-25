public protocol AnalyticsProperty {
    var name: String { get }
    var value: Encodable { get }
}
