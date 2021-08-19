import SwiftUI

import CoreAdapters
import CoreAuthentication
import CoreNetworking
import CoreEnvironment
import CoreInjector
import JAuthentication
import JLibrary


fileprivate let routerService = RouterService() // TODO handle this


@main
struct LearningJourneyApp: App {
    init() {
        print(DefaultEnvironment.baseUrl)
        registerDependencies()
        registerRouteHandlers()
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
    }
    
    private func registerRouteHandlers() {
        routerService.register(routeHandler: LibraryRouteHandler())
        routerService.register(routeHandler: AuthenticationRouteHandler())
    }
}
