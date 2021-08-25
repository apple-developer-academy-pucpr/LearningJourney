struct FirebaseHandler: AnalyticsHandler {
    var destination: AnalyticsDestination { .firebase }
    let logger: ThirdPartyLogger = FirebaseLogger()
}
