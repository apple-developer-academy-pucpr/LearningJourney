import FirebaseAnalytics
import Firebase

final class FirebaseLogger: ThirdPartyLogger {
    
    // MARK: - Dependencies
    
    private let logger: FirebaseLogging.Type
    
    // MARK: - Initialization
    
    init(
        logger: FirebaseLogging.Type = Analytics.self
    ) {
        self.logger = logger
    }
    
    func log(event: AnalyticsPayload) {
        logger.logEvent(
            event.name,
            parameters: event.parameters
        )
    }
}
