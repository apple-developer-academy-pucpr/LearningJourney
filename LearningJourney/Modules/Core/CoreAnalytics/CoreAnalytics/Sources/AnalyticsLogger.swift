public protocol AnalyticsLogging {
    func log(event: AnalyticsEvent)
}

public typealias AnalyticsEvent = AnalyticsPayload & AnalyticsDispatching

public final class AnalyticsLogger: AnalyticsLogging {
    // MARK: - Dependencies
    
    private let handlers: [AnalyticsHandler]
    
    // MARK: - Initialization
    
    init(handlers: [AnalyticsHandler]? = nil) {
        self.handlers = handlers ?? AnalyticsLogger.defaultHandlers
    }
    
    // MARK: - Logging
    
    public func log(event: AnalyticsEvent) {
        handlers
            .filter { event.destinations.contains($0.destination) }
            .forEach { $0.logger.log(event: event) }
    }
}

// TODO review if this is the best injection method
private extension AnalyticsLogger {
    static var defaultHandlers: [AnalyticsHandler] {
        [
            FirebaseHandler(),
        ]
    }
}
