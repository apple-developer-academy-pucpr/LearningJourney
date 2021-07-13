import SwiftUI

import CoreAuthentication
import CoreEnvironment
import CoreInjector
import JAuthentication
import JLibrary


fileprivate let routerService = RouterService() // TODO handle this


@main
struct LearningJourneyApp: App {
    init() {
        print(DefaultEnvironment.baseUrl)
        routerService.register({ routerService }, for: RoutingService.self)
        routerService.register(routeHandler: LibraryRouteHandler())
    }
    
    var body: some Scene {
        WindowGroup {
            routerService
                .initialize(using: LibraryFeature.self)
                .authenticationSheet()
        }
    }
}
