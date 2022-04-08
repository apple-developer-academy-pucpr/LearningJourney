import SwiftUI

import CoreAdapters
import CoreAuthentication
import CoreNetworking
import CoreEnvironment
import CoreInjector
import JAuthentication
import JLibrary
import CoreAnalytics

@main
struct LearningJourneyApp: App {
    
    private let routerService = RouterService()
    
    init() {
        print(DefaultEnvironment.baseUrl)
        registerDependencies()
        registerRouteHandlers()
        initializeAnalytics()
    }
    
    var body: some Scene {
        WindowGroup {
            routerService
                .initialize(using: LibraryFeature.self)
                .authenticationSheet(using: routerService.feature(for: AuthenticationFeature.self))
        }
    }
    
    private func registerDependencies() {
        routerService.register({ routerService }, for: RoutingService.self)
        routerService.register({ ApiFactory() }, for: ApiFactoryProtocol.self)
        routerService.register({ TokenManager.shared }, for: TokenCleaning.self)
        routerService.register({ NotificationCenter.default }, for: NotificationCenterProtocol.self)
        routerService.register({ AnalyticsLogger() }, for: AnalyticsLogging.self)
    }
    
    private func registerRouteHandlers() {
        routerService.register(routeHandler: LibraryRouteHandler())
        routerService.register(routeHandler: AuthenticationRouteHandler())
    }
    
    private func initializeAnalytics() {
        FirebaseStarter.start()
    }
}
