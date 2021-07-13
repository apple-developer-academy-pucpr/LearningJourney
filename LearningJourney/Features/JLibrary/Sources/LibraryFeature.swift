import SwiftUI
import CoreInjector

public struct LibraryFeature: Feature {
    
    // MARK: - Dependencies
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
            return scenesFactory.resolveObjectivesListScene(using: route)
        }
        
        if route == nil {
            return scenesFactory.resolveLibraryScene(for: self, using: nil)
        }
        preconditionFailure("Trying to resolve feature for unkown route \(String(describing: route))")
    }
}

public struct LibraryRouteHandler: RouteHandling {
    
    public var routes: [Route.Type] {
        [
            LibraryRoute.self,
            ObjectivesRoute.self
        ]
    }
    
    public func destination(for route: Route) -> Feature.Type {
        LibraryFeature.self
    }
    
    public init() {}
}

struct LibraryRoute: Route {
    static var identifier: String  { "library.libraryRoute" }
}

struct ObjectivesRoute: Route {
    static var identifier: String { "library.objectivesRoute" }
    let goal: LearningGoal
}
