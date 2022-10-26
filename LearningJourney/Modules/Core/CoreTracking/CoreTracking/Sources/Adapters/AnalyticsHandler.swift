protocol ThirdPartyLogger {
    func log(event: AnalyticsPayload)
}

protocol AnalyticsHandler {
    var destination: AnalyticsDestination { get }
    var logger: ThirdPartyLogger { get }
}
