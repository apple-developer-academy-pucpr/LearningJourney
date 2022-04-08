public protocol AnalyticsLogging {
    func log(event: AnalyticsEvent)
}

public protocol AnalyticsEvent: AnalyticsPayload & AnalyticsDispatching {}

public final class AnalyticsLogger: AnalyticsLogging {
    // MARK: - Dependencies
    
    private let handlers: [AnalyticsHandler]
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(handlers: AnalyticsLogger.defaultHandlers)
    }
    
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

private extension AnalyticsLogger {
    static let defaultHandlers: [AnalyticsHandler] = {
        [
            FirebaseHandler(),
        ]
    }()
}
