/// Responsible for setting up an analytics service
protocol AnalyticsStarter {
    /// This method should configure an analytics service and make sure that it's ready to be used
    static func start()
}
