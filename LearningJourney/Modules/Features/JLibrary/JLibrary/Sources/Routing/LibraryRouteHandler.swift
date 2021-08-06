import CoreInjector

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
