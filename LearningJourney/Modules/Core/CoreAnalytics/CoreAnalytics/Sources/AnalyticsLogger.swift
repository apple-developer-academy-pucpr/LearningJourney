public protocol AnalyticsLogging {
    func log(event: AnalyticsEvent)
}

protocol AnalyticsHandler {
    var destination: AnalyticsDestination { get }
    var logger: AnalyticsLogger { get }
}

public final class AnalyticsLogger: AnalyticsLogging {
    // MARK: - Dependencies
    
    private let handlers: [AnalyticsHandler]
    
    // MARK: - Initialization
    
    init(handlers: [AnalyticsHandler]) {
        self.handlers = handlers
    }
    
    // MARK: - Logging
    
    public func log(event: AnalyticsEvent) {
        handlers
            .filter { event.destinations.contains($0.destination) }
            .forEach { $0.logger.log(event: event) }
    }
}
