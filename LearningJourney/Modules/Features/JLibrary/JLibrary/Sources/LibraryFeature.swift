import SwiftUI
import CoreInjector
import CoreNetworking

public struct LibraryFeature: Feature {
    
    // MARK: - Dependencies
    
    @Dependency var api: ApiFactoryProtocol
    @Dependency var routingService: RoutingService
    
    private let scenesFactory: LibraryScenesFactoryProtocol
    
    // MARK: - Initialization
    
    public init() {
        let factory = LibraryScenesFactory(
            libraryAssembler: LibraryAssembler(),
            objectivesListAssembler: ObjectivesListAssembler()
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
        
        if route == nil {
            return scenesFactory.resolveLibraryScene(for: self, using: nil)
        }
        preconditionFailure("Trying to resolve feature for unkown route \(String(describing: route))")
    }
}
