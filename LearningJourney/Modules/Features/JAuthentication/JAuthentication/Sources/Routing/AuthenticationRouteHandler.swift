import CoreInjector

public final class AuthenticationRouteHandler: RouteHandling {
    public var routes: [Route.Type] {[
        LoginRoute.self
    ]}
    
    public func destination(for route: Route) -> Feature.Type {
        AuthenticationFeature.self
    }
    
    public init() {}
}
