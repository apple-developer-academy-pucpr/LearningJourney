public struct AnalyticsProperty {
    let name: String
    let value: AnyHashable
    
    public init(name: String, value: AnyHashable) {
        self.name = name
        self.value = value
    }
}
