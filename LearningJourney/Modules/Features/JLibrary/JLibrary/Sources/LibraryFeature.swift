import SwiftUI
import CoreInjector
import CoreNetworking
import CoreAuthentication
import CoreAdapters

public struct LibraryFeature: Feature {
    
    // MARK: - Dependencies
    
    @Dependency var api: ApiFactoryProtocol
    @Dependency var routingService: RoutingService
    @Dependency var tokenCache: TokenCleaning
    @Dependency var notificationCenter: NotificationCenterProtocol
    
    private let scenesFactory: LibraryScenesFactoryProtocol
    
    // MARK: - Initialization
    
    public init() {
        let factory = LibraryScenesFactory(
            libraryAssembler: LibraryAssembler(),
            objectivesListAssembler: ObjectivesListAssembler(),
            createObjectiveAssembler: CreateObjectiveAssembler()
        )
        self.init(
            scenesFactory: factory
        )
    }
    
    init(scenesFactory: LibraryScenesFactoryProtocol) {
        self.scenesFactory = scenesFactory
    }
    
    // MARK: - Feature resolving
    
    public func build(using route: Route?) -> AnyView {
        if let route = route as? ObjectivesRoute {
            return scenesFactory.resolveObjectivesListScene(for: self, using: route)
        }
        
        if let route = route as? NewObjectiveRoute {
            return scenesFactory.resolveCreateObjectiveScene(for: self, route: route)
        }
        
        if route == nil {
            return scenesFactory.resolveLibraryScene(for: self, using: nil)
        }
        preconditionFailure("Trying to resolve feature for unkown route \(String(describing: route))")
    }
}
